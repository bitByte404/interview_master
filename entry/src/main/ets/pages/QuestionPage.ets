import { HcNavBar, HcTag, QuestionPageParams } from '../commons/components'
import { router } from '@kit.ArkUI'
import { QuestionDetail } from '../models'
import { req } from '../commons/utils'
import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct QuestionPage {
  @StorageProp('bottomHeight') bottomHeight: number = 0

  @Builder
  TitleBuilder(text: string) {
    Row() {
      Text()
        .width(2)
        .height(12)
        .backgroundColor($r('app.color.black'))
        .margin({ right: 13 })
      Text(text)
        .fontWeight(700)
    }
    .width('100%')
    .padding({ top: 10 })
    .height(32)
  }

  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: '点赞' })
      MenuItem({ content: '收藏' })
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
    }
    .width(108)
  }

  @State item: QuestionDetail = {} as QuestionDetail
  controller: webview.WebviewController = new webview.WebviewController()

  async aboutToAppear() {
    const params = router.getParams() as QuestionPageParams
    if (params) {
      this.item = params.item as QuestionDetail
      this.item = await this.getQuestionDetail()
      // 请求和加载html页面都是异步的
      // 血药保证在数据加载结束之后，重新执行question.html页面
      this.controller.loadUrl($rawfile('question.html'))
    }
  }

  getQuestionDetail(): Promise<QuestionDetail> {
    return req.request<QuestionDetail>({
      url: `/question/${this.item.id}`,
    })
  }

  build() {
    Column() {
      HcNavBar({ title: '试题详情', showRightIcon: false })
      // 题目
      this.TitleBuilder('题目：')
      Text(this.item.stem)
        .width('100%')
        .padding(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Row({ space: 12 }) {
        ForEach(this.item.stage, (item: string, index) => {
          HcTag({ text: item })
        })
        Blank()
        Image($r("app.media.ic_home_more"))
          .width(20)
          .aspectRatio(1)
          .bindMenu(this.MenuBuilder())
      }
      .width('100%')
      .padding({ bottom: 16, left: 16, right: 16 })

      Divider()
        .strokeWidth(8)
        .color($r('app.color.common_gray_bg'))
      // 内容
      this.TitleBuilder('答案：')
      // 需要使用鸿蒙Web组件调用web页面中的writeHtml方法，最终传入html字符串
      // 实现高亮效果
      // 由于web加载html页面是异步的，所以必须等到加载完毕之后，才能调用writeHtml方法
      Web({src: $rawfile('question.html'), controller: this.controller})
        .layoutWeight(1)
        .padding(16)
        .onPageEnd(() => {
          // 加载页面结束
          this.controller.runJavaScript(`writeHtml(\`${this.item.answer || ''}\`)`)
        })

      Row({ space: 80 }) {
        Row() {
          Image($r('sys.media.ohos_ic_public_arrow_left'))
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_01'))
          Text(' 上一题')
            .fontColor($r('app.color.common_gray_01'))
        }

        Row() {
          Text('下一题 ')
            .fontColor($r('app.color.common_gray_03'))
          Image($r('sys.media.ohos_ic_public_arrow_right'))
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_03'))
        }
      }
      .height(44)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: this.bottomHeight })
  }
}