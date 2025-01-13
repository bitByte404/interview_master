import { HcLoadingDialog, HcNavBar, HcTag, QuestionPageParams } from '../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { QuestionDetail, QuestionOptParams } from '../models'
import { req } from '../commons/utils'
import { webview } from '@kit.ArkWeb'
import { QuestionShareDialog } from '../views/Question/QuestionShareDialog'

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
      MenuItem({ content: this.item.likeFlag ? '点赞' : '取消点赞' })
        .onClick(() => {
          this.questionOpt(1, this.item.likeFlag == 0 ? 1 : 0)
        })
      MenuItem({ content: this.item.collectFlag ? '收藏' : '取消收藏' })
        .onClick(() => {
          this.questionOpt(2, this.item.collectFlag == 0 ? 1 : 0)
        })
      MenuItem({ content: '点我反馈' })
      MenuItem({ content: '试题分享' })
        .onClick(() => {
          this.shareDialog.open()
        })
    }
    .width(108)
  }

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

  @State item: QuestionDetail = {} as QuestionDetail
  @State list: QuestionDetail[] = []
  @State questionIndex: number = 0
  controller: webview.WebviewController = new webview.WebviewController()
  // 创建loading dialog的实例对象
  dialog = new CustomDialogController({
    builder: HcLoadingDialog(),
    // 自定义弹窗样式
    customStyle: true,
  })

  // 创建分享 dialog的实例对象
  shareDialog = new CustomDialogController({
    builder: QuestionShareDialog({item: this.item}),
    customStyle: true
  })


  async aboutToAppear() {
    const params = router.getParams() as QuestionPageParams
    if (params) {
      // 试题详情
      this.item = params.item as QuestionDetail
      // 试题列表
      this.list = params.list as QuestionDetail[]
      this.list.findIndex(item => item.id == this.item.id)
      if (!this.item.answer) {
        // 加载前开启loading效果
        this.dialog.open()
        this.item = await this.getQuestionDetail(this.item.id)
        // 默认加载的试题，防止数组中进行缓存
        this.list[this.questionIndex] = this.item
        // 加载后关闭loading效果
        this.dialog.close()
      }
      // 请求和加载html页面都是异步的
      // 血药保证在数据加载结束之后，重新执行question.html页面
      this.controller.loadUrl($rawfile('question.html'))
    }
  }

  onPageHide(): void {
    this.dialog.close()
    this.shareDialog.close()
  }

  // 获取试题详情
  getQuestionDetail(id: string): Promise<QuestionDetail> {
    return req.request<QuestionDetail>({
      url: `/question/${id}`,
    })
  }

  // 切换试题
  async  toggleQuestion(step: number) {
    const index = this.questionIndex + step
    if (index < 0 || index >= this.list.length) {
      return promptAction.showToast({
        message: '没有更多试题了'
      })
    }
    this.questionIndex = index
    const item = this.list[index]
    // 加载完整的试题数据
    if (item.answer) {
      // 不需要请求，直接赋值
      this.item = item
    } else {
      this.dialog.open()
      // 发请求
      const fullItem = await this.getQuestionDetail(item.id)
      this.dialog.close()
      // 将数据放入list
      this.list[index] = fullItem
      this.item = fullItem
    }
    this.controller.loadUrl($rawfile('question.html'))
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
      Web({ src: $rawfile('question.html'), controller: this.controller })
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
            .fillColor(this.questionIndex <= 0
              ? $r('app.color.common_gray_01')
              : $r('app.color.common_gray_03'))
          Text(' 上一题')
            .fontColor(this.questionIndex <= 0
              ? $r('app.color.common_gray_01')
              : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.toggleQuestion(-1)
        })

        Row() {
          Text('下一题 ')
            .fontColor(this.questionIndex >= this.list.length - 1
              ? $r('app.color.common_gray_01')
              : $r('app.color.common_gray_03'))
          Image($r('sys.media.ohos_ic_public_arrow_right'))
            .width(20)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_03'))
            .fillColor(this.questionIndex >= this.list.length - 1
              ? $r('app.color.common_gray_01')
              : $r('app.color.common_gray_03'))
        }
        .onClick(() => {
          this.toggleQuestion(1)
        })
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