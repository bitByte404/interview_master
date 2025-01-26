import { InterviewDetail, InterviewItem, QuestionOptParams, RelatedQuestion } from '../models'
import { webview } from '@kit.ArkWeb'
import { HcLoadingDialog, HcNavBar, HcTag } from '../commons/components'
import { logger, req } from '../commons/utils'
import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct InterviewDetailPage {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @State item: InterviewDetail = {} as InterviewDetail
  controller: webview.WebviewController = new webview.WebviewController()
  dialog = new CustomDialogController({
    builder: HcLoadingDialog(),
    customStyle: true
  })

  async questionOpt(optType: 1 | 2, flag: 0 | 1) { // 1点赞，2收藏
    // flag: 执行的操作 1执行，0取消
    try {
      const data: QuestionOptParams = {
        id: this.item.id,
        type: 0,
        optType
      }
      await req.request<null, QuestionOptParams>({
        url: flag == 1 ? '/question/opt' : '/question/unOpt',
        method: 'post',
        data
      })
      if (optType == 1) {
        this.item.likeFlag = flag
        promptAction.showToast({ message: flag == 1 ? '点赞成功' : '取消点赞' })
      }
      if (optType == 2) {
        this.item.collectFlag = flag
        promptAction.showToast({ message: flag == 1 ? '收藏成功' : '取消收藏' })
      }
    } catch (error) {
      promptAction.showToast({ message: '操作失败' })
    }
  }

  @Builder
  MenuBuilder() {
    Menu() {
      MenuItem({ content: this.item.likeFlag ? '点赞' : '取消点赞' })
        .onClick(() => {
          this.questionOpt(1, this.item.likeFlag == 0 ? 1 : 0)
        })
      MenuItem({ content: this.item.collectFlag ? '收藏' : '取消收藏' })
        .onClick(() => {
          this.questionOpt(2, this.item.collectFlag == 0 ? 1 : 0)
        })
      MenuItem({ content: '点我反馈' })
      // MenuItem({ content: '试题分享' })
      //   .onClick(() => {
      //     // this.shareDialog.open()
      //   })
    }
    .width(108)
  }

  async aboutToAppear() {
    const item = router.getParams() as InterviewItem
    if (item) {
      this.dialog.open()
      this.item = item as InterviewDetail
      this.item = await this.getInterviewDetail(this.item.id)
      logger.warn('detailMore', JSON.stringify(this.item.relatedQuestions))
      this.dialog.close()
    }
    this.controller.loadUrl($rawfile('question.html'))
  }

  getInterviewDetail(id: string): Promise<InterviewDetail> {
    return req.request<InterviewDetail>({
      url: `/question/${id}`,
    })
  }

  extractTextFromPTag(input: string): string {
    // 使用正则表达式匹配以 <p> 标签开头的内容
    const pTagPattern = /^<p>(.*?)<\/p>/s;
    const match = input.match(pTagPattern);

    if (match && match[1]) {
      // 返回 <p> 标签内的文本内容
      return match[1];
    } else {
      // 如果没有匹配到以 <p> 标签开头的内容，返回空字符串
      return '';
    }
  }


  build() {
    Column() {
      HcNavBar({ title: '面经详情', showRightIcon: true, rightIcon: $r('app.media.icon_share') })
        .margin({ bottom: 6 })
      Row() {
        Column({ space: 14 }) {
          Text(`${this.item.stem}`)
            .width('100%')
            .maxLines(2)
            .fontSize(18)
            .fontWeight(600)
          Text() {
            Span(`${this.item.createdAt} | `)
            Span(` ${this.item.views}浏览 | `)
            Span(` ${this.item.likeCount}点赞`)
          }
          .fontSize(14)
          .fontWeight(400)
          .fontColor($r('app.color.common_gray_01'))
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r("app.media.ic_home_more"))
          .width(20)
          .aspectRatio(1)
          .bindMenu(this.MenuBuilder())
      }
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)
      .height(80)

      Divider()
        .strokeWidth(0.5)
        .color($r('app.color.common_gray_border'))
      Scroll() {
        Column() {
          Web({ src: $rawfile('question.html'), controller: this.controller })
            .onPageEnd(() => {
              this.controller.runJavaScript(`writeHtml(\`${this.item.content || ''}\`)`)
            })
       /*   if (this.item.relatedQuestions?.length != 0) {
            Row() {
              Text('相关问题')
                .fontColor($r('app.color.common_gray_01'))
                .fontSize(16)
              Column() {
                ForEach(this.item.relatedQuestions, (question: RelatedQuestion, index) => {
                  Flex() {
                    if (this.extractTextFromPTag(question.stem)) {
                      Image($r('app.media.icon_more_question'))
                        .height(20)
                        .fillColor($r('app.color.common_green'))
                      Text(this.extractTextFromPTag(question.stem))
                        .fontColor($r('app.color.common_green'))
                    }
                  }
                  .margin({left: 5})
                })
              }
            }
            .padding(10)
            .width('100%')
            .backgroundColor($r('app.color.common_gray_bg'))
            .borderRadius(8)
          }*/
        }
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ bottom: this.bottomHeight, left: 16, right: 16 })
  }
}