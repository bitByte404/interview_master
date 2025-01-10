import { HcClockIn, HcSearchBox } from "../commons/component"
import { HomeCategory } from "../views/Home/HomeCategory"

@Component
@Preview
export struct HomePage {
  build() {
    Column() {
      // 顶部搜索栏
      Row({ space: 16 }) {
        Image($r('app.media.ic_home_scan'))
          .width(24)
          .aspectRatio(1)
        HcSearchBox({ layoutWeightValue: 1 })
        HcClockIn({ clockInCount: 3 })
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
      HomeCategory()
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_gray_bg'))
  }

  @Builder
  swiperBuilder(item: ResourceStr) {
    Row() {
      Image(item)
        .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
}