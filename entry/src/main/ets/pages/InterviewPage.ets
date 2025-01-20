import { HcSearchBox } from "../commons/components";
import { SortType } from "../models";
import { InterviewListComp } from "../views/Interview/InterviewTabComp";

@Component
@Preview
export struct InterviewPage {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  @State selectTabIndex: number = 0

  @Builder
  TabBarBuilder(type: string, index: number) {
    // 列表
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(type)
          .fontSize(15)
          .fontColor(this.selectTabIndex == index
            ? $r('app.color.black')
            : $r('app.color.common_gray_01'))
          .height(40)
        Text()
          .width(this.selectTabIndex == index ? 20 : 0)
          .height(2)
          .backgroundColor($r('app.color.common_green'))
          .animation({ duration: this.selectTabIndex == index ? 300 : 0 })
      }
    }
    .padding({ left: 16, right: index == 1 ? 16 : 0 })
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        HcSearchBox({
          boxWidth: '100%',
          ph: '请输入关键词',
        })
          .padding({
            left: 5
          })
          .layoutWeight(1)
          .margin({
            left: 10,
            top: 10,
            right: 10
          })
        Image($r('app.media.icon_checkin'))
          .width(30)
          .margin({
            right: 10
          })
      }

      Tabs({ index: $$this.selectTabIndex }) {

        TabContent() {
          InterviewListComp({
            sort: SortType.Default
          })
        }
        .tabBar(this.TabBarBuilder('最新', 0))

        TabContent() {
          InterviewListComp({
            sort: SortType.Commend
          })
        }
        .tabBar(this.TabBarBuilder('推荐', 1))
      }
      .tabIndex(this.selectTabIndex)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.white'))
    .padding({
      top: this.topHeight,
      bottom: this.bottomHeight
    })
  }
}