import { HcClockIn, HcSearchBox, QuestionPageParams } from "../commons/components"
import { auth, req, UserInterviewKey } from "../commons/utils"
import { QuestionDetail, User } from "../models"
import { HomeCategory } from "../views/Home/HomeCategory"
import { promptAction, router } from "@kit.ArkUI"
import { scanBarcode } from "@kit.ScanKit"


@Component
@Preview
export struct HomePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp(UserInterviewKey)
  user: User = {} as User

  build() {
    Column() {
      // 顶部搜索栏
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            // 执行扫码逻辑
            // 1. 判断是否登录
            // 2. 登录后执行扫码逻辑
            auth.checkAuth(async () => {
              // 执行对应的业务逻辑
              if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
                // 获取扫码结果
                const result = await scanBarcode.startScanForResult(getContext(this))
                try  {
                  const item = await req.request<QuestionDetail>({
                   url: `/question/${result.originalValue}`
                  })
                  // 跳转界面
                  router.pushUrl({
                    url: 'pages/QuestionPage',
                    params: {
                      item,
                      list: [item]
                    } as QuestionPageParams
                  })
                }catch (error) {
                  promptAction.showToast({
                    message: '该试题不存在'
                  })
                }
              } else {
                promptAction.showToast({ message: '该设备不具备扫码能力' })
              }
            })
          })
        HcSearchBox({ layoutWeightValue: 1 })
        HcClockIn({ clockInCount: this.user.clockinNumbers })
      }
      .padding({ left: 16, right: 16 })
      .height(64)
      .width('100%')

      // 轮播图
      Swiper() {
        ForEach([$r('app.media.banner_pj'), $r('app.media.banner_ai'), $r('app.media.banner_qa')],
          (item: ResourceStr, index) => {
            this.swiperBuilder(item)
          })
      }
      .autoPlay(true)
      .margin({ bottom: 16 })
      .indicator(
        DotIndicator.dot()
          .bottom(4)
          .selectedColor($r('app.color.white'))
          .selectedItemWidth(20)
      )

      // 分类
      Column() {
        HomeCategory()
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white'))
    .padding({
      top: this.topHeight,
    })
  }

  @Builder
  swiperBuilder(item: ResourceStr) {
    Row() {
      Image(item)
        .width('100%')
    }
    .constraintSize({
      minHeight: 140
    })
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
}