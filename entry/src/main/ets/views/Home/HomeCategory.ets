import { QuestionType } from "../../models"

@Component
export struct HomeCategory {
  @State questionList: QuestionType[] = [
    { id: 1, name: 'ArkTS', displayNewestFlag: 0 },
    { id: 2, name: 'ArkUI', displayNewestFlag: 1 },
    { id: 3, name: 'Hap', displayNewestFlag: 1 },
    { id: 4, name: 'Hsp', displayNewestFlag: 0 },
    { id: 5, name: 'Har', displayNewestFlag: 0 },
    { id: 6, name: 'Ability', displayNewestFlag: 0 },
    { id: 7, name: 'Stage', displayNewestFlag: 0 },
    { id: 8, name: 'Kit', displayNewestFlag: 0 }
  ]
  @State activeIndex: number = 0

  @Builder
  TabBarBuilder(item: QuestionType, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(item.name)
          .fontSize(15)
          .fontColor(this.activeIndex == index ? $r('app.color.black') : $r('app.color.common_gray_01'))
          .height(40)
        Text()
          .width(this.activeIndex == index ? 20 : 0)
          .height(2)
          .backgroundColor($r('app.color.black'))
          .animation({ duration: this.activeIndex == index ? 300 : 0})
      }
      if (item.displayNewestFlag) {
        Image($r('app.media.ic_home_new'))
          .height(15)
          .margin({
            left: 5
          })
      }
    }
    .padding({ left: 16, right: index == this.questionList.length - 1 ? 16 : 0 })
  }

  build() {
    Tabs() {
      ForEach(this.questionList, (item: QuestionType, index) => {
        TabContent() {
          Row() {
            Column() {

            }
          }
        }
        .tabBar(this.TabBarBuilder(item, index))
      })
    }
    .onChange((index) => {
      this.activeIndex = index
    })
    .barHeight(44)
    .divider({
      strokeWidth: 1,
      color: $r('app.color.common_gray_border')
    })
    .scrollable(false)
    .barMode(BarMode.Scrollable)
  }
}

