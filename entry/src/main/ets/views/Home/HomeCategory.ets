import { QuestionListComp } from "../../commons/component"
import { http } from "../../commons/utils/Http"
import { QuestionType } from "../../models"

@Component
export struct HomeCategory {
  @State questionList: QuestionType[] = []
  @State activeIndex: number = 0

  aboutToAppear() {
    this.getQuestionList()
  }

  async getQuestionList() {
    this.questionList = await http.request<QuestionType[]>({
      url: 'question/type',
    })
  }

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
          .animation({ duration: this.activeIndex == index ? 300 : 0 })
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
          QuestionListComp()
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

