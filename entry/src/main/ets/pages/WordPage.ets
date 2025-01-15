import { HcNavBar } from '../commons/components'
import { JSON, util } from '@kit.ArkTS'
import { promptAction } from '@kit.ArkUI'
import { webview } from '@kit.ArkWeb'
import { WordDialog } from '../views/Word/WordDialog'

interface WordItem {
  en: string
  zh: string
  code: string
}

type Words = Record<string, WordItem[]>

@Entry
@Component
struct WordPage {
  @State words: Words = {}
  @State wordKey: string = ''
  @State showTypeSheet: boolean = false
  @State showCodeSheet: boolean = false
  @State currentCode: string = ''
  @State currentEn: string = ''
  @State currentZh: string = ''
  scroller = new Scroller()
  webController = new webview.WebviewController()
  dialog = new CustomDialogController({
    builder: WordDialog({
      en: this.currentEn,
      zh: this.currentZh
    }), customStyle: true
  })

  aboutToAppear(): void {
    this.initWords()
  }

  initWords() {
    const ctx = getContext(this)
    // 获取二进制数据
    const uint8Array = ctx.resourceManager.getRawFileContentSync('word.json')
    // 实例化文本解析工具
    const textDecoder = new util.TextDecoder()
    // 解析文本
    const jsonStr = textDecoder.decodeToString(uint8Array)
    this.words = JSON.parse(jsonStr) as Words
    // 获取数组中第一项
    this.wordKey = Object.keys(this.words)[0]
  }

  @Builder
  TypeSheetBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(Object.keys(this.words), (key: string) => {
          Button() {
            Text(key)
              .fontSize(14)
              .fontColor(key == this.wordKey ? $r('app.color.common_green') : $r('app.color.common_gray_01'))
          }
          .onClick(() => {
            this.wordKey = key
            this.showTypeSheet = false
            this.scroller.scrollEdge(Edge.Top)
          })
          .backgroundColor($r('app.color.common_gray_bg'))
          .padding({
            top: 6,
            right: 12,
            bottom: 6,
            left: 12
          })
          .margin({ right: 12, bottom: 12 })
        })
      }
    }
  }

  @Builder
  CodeSheetBuilder() {
    Column() {
      Web({ src: $rawfile('word.html'), controller: this.webController })
        .width('100%')
        .height(400)
        .backgroundColor($r('app.color.common_gray_bg'))
        .onPageEnd(() => {
          this.webController.runJavaScript(`writeHtml(\`${this.currentCode}\`)`)
        })
    }
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 34
    })
  }

  build() {
    Column() {
      HcNavBar({ title: '常用单词', showRightIcon: false })
      Row() {
        Column({ space: 4 }) {
          Text('开发常用词汇')
          Text(`共 ${this.words[this.wordKey].length} 个单词`)
            .fontSize(12)
            .fontColor($r('app.color.common_gray_03'))
        }
        .alignItems(HorizontalAlign.Start)

        Row() {
          Text(this.wordKey)
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_01'))
        }
        .onClick(() => {
          this.showTypeSheet = true
        })
        .bindSheet($$this.showTypeSheet, this.TypeSheetBuilder,
          {
            height: 400,
            title: {
              title: '选择分类',
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(16)
      .border({ width: { top: 0.5 }, color: $r('app.color.common_gray_bg') })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))

      List({ scroller: this.scroller }) {
        ForEach(this.words[this.wordKey], (item: WordItem) => {

          ListItem() {
            Row({ space: 6 }) {
              Image($r('sys.media.ohos_ic_public_sound'))
                .width(20)
                .aspectRatio(1)
                .alignSelf(ItemAlign.Start)
                .fillColor($r('app.color.common_gray_03'))
                .onClick(() => {
                  this.currentEn = item.en
                  this.currentZh = item.zh
                  this.dialog.open()
                })
              Column({ space: 10 }) {
                Text(item.zh)
                  .fontWeight(FontWeight.Bold)
                Text(item.en)
                  .fontSize(14)
                  .fontColor($r('app.color.common_gray_03'))
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Row() {
                Text('详细代码')
                  .fontSize(12)
                  .fontColor(item.code ? $r('app.color.common_gray_01') : '#dddddd')
                Image($r('sys.media.ohos_ic_public_arrow_right'))
                  .width(16)
                  .aspectRatio(1)
                  .fillColor(item.code ? $r('app.color.common_gray_01') : '#dddddd')
              }
              .alignSelf(ItemAlign.End)
              .onClick(() => {
                if (item.code) {
                  this.currentCode = item.code
                  this.showCodeSheet = true
                } else {
                  promptAction.showToast({ message: '暂无详细代码' })
                }
              })
            }
            .padding(16)
          }
        })
      }
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_bg')
      })
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .bindSheet($$this.showCodeSheet, this.CodeSheetBuilder(), {
      title: {
        title: '详细代码'
      },
      height: 400
    })
  }
}


