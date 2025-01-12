import { HcSkeleton, HcSkeletonItem, QuestionListComp } from "../../commons/component"
import { req } from "../../commons/utils/Http"
import { QuestionItem, QuestionType, SortType } from "../../models"

@Component
export struct HomeCategory {
  @State questionList: QuestionType[] = []
  @State activeIndex: number = 0
  @State isShow: boolean = false
  @State filterIndex: number = 0 // 高亮的下标
  @State filterSort: SortType = SortType.Default // 题目的高亮排序规则
  @State sort: SortType = SortType.Default
  @State isLoading: boolean = false

  aboutToAppear() {
    this.getQuestionList()
  }

  async getQuestionList() {
    this.isLoading = true
    this.questionList = await req.request<QuestionType[]>({
      url: 'question/type',
    })
    this.isLoading = false
  }

  @Builder
  FilterSheetBuilder() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_03'))
          .onClick(() => {
            this.filterSort = 0
            this.filterIndex = 0
          })
        Text('筛选题目')
          .layoutWeight(1)
          .fontSize(18)
          .fontWeight(500)
          .fontColor($r('app.color.black'))
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontWeight(500)
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
          .onClick(() => {
            this.isShow = false
            this.activeIndex = this.filterIndex
            this.sort = this.filterSort
          })
      }
      .margin({ bottom: 4, top: 4 })

      Text('题目排序')
        .textTitle()
      Flex({ wrap: FlexWrap.Wrap }) {
        FilterButton({ text: '默认', selected: this.filterSort == SortType.Default })
          .onClick(() => {
            this.filterSort = SortType.Default
          })
        FilterButton({
          text: '浏览量',
          isSort: true,
          selected: this.filterSort == SortType.ViewLow
            || this.filterSort == SortType.ViewHigh,
          sort: this.filterSort
        })
          .onClick(() => {
            this.filterSort =
              this.filterSort == SortType.ViewLow ?
              SortType.ViewHigh : SortType.ViewLow
          })
        FilterButton({
          text: '难度',
          isSort: true,
          selected: this.filterSort == SortType.DifficultyLow
            || this.filterSort == SortType.DifficultyHigh,
          sort: this.filterSort
        })
          .onClick(() => {
            this.filterSort =
              this.filterSort == SortType.DifficultyLow
                ? SortType.DifficultyHigh
                : SortType.DifficultyLow
          })
        FilterButton({ text: '推荐', selected: this.filterSort == SortType.Commend })
          .onClick(() => {
            this.filterSort = SortType.Commend
          })
      }

      Text('选择分类')
        .textTitle()
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionList, (item: QuestionType, index) => {
          FilterButton({
            text: item.name,
            isNew: item.displayNewestFlag == 1,
            selected: this.filterIndex == index
          })
            .onClick(() => {
              this.filterIndex = index
            })
        })
      }
    }
    .padding(16)
    .backgroundColor($r('app.color.white'))
    .height('100%')
  }

  @Builder
  TabBarBuilder(item: QuestionType, index: number) {
    // 列表
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(item.name)
          .fontSize(15)
          .fontColor(this.activeIndex == index
            ? $r('app.color.black')
            : $r('app.color.common_gray_01'))
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

  @Builder
  SkeletonBuilder() {
    Column() {
      HcSkeleton() {
        Column() {
          Row({ space: 10 }) {
            HcSkeletonItem({ widthValue: '15%' })
            HcSkeletonItem({ widthValue: '20%' })
            HcSkeletonItem({ widthValue: '10%' })
            HcSkeletonItem({ widthValue: '13%' })
            HcSkeletonItem({ widthValue: '16%' })
          }.width('100%')
          .height(44)

          ForEach(new Array(6).fill(0), () => {
            Column({ space: 10 }) {
              HcSkeletonItem({ widthValue: '70%' })
              HcSkeletonItem({ widthValue: '75%' })
            }
            .width('100%')
            .height(80)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
          })
        }
        .padding({ left: 16, right: 16 })
      }
    }
  }

  build() {
    if ( this.isLoading) {
      // 骨架屏组件
      this.SkeletonBuilder()
    } else {
      Stack({ alignContent: Alignment.TopEnd }) {
        Tabs({ index: this.activeIndex }) {
          ForEach(this.questionList, (item: QuestionType, index) => {
            TabContent() {
              // 试题列表
              QuestionListComp({
                typeId: item.id,
                sort: this.sort
              })
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

        Row() {
          Image($r('app.media.ic_home_filter'))
            .width(24)
            .aspectRatio(1)
        }
        .backgroundColor($r('app.color.white'))
        .linearGradient({
          angle: 90,
          colors: [['#00ffffff', 0], ['#ffffff', 0.285]]
        })
        .width(56)
        .height(44)
        .justifyContent(FlexAlign.Center)
        .bindSheet($$this.isShow, this.FilterSheetBuilder(), {
          height: 400,
          showClose: false
        })
        .onClick(() => {
          this.isShow = true
          // 同步tab的激活状态
          this.filterIndex = this.activeIndex
        })
      }

    }
  }
}

@Extend(Text)
function textTitle() {
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.black'))
  .width('100%')
  .margin({ top: 20 })
}


@Component
struct FilterButton {
  text: string = ''
  isNew: boolean = false
  isSort: boolean = false
  @Prop selected: boolean = false
  @Prop sort: SortType = SortType.Default

  build() {
    Row() {
      Text(this.text)
        .fontSize(12)
        .fontColor(this.selected ? $r('app.color.common_main_color') : $r('app.color.black'))
      if (this.isNew) {
        Image($r('app.media.ic_home_new'))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .position({ right: -26, top: -7 })
      }
      if (this.isSort) {
        Column() {
          Image($r('sys.media.ohos_ic_public_arrow_up'))
            .fillColor(this.selected && this.sort % 2 == 1
              ? $r('app.color.common_main_color')
              : $r('app.color.black'))
            .size({ width: 12, height: 6 })
          Image($r('sys.media.ohos_ic_public_arrow_down'))
            .size({ width: 12, height: 6 })
            .fillColor(this.selected && this.sort % 2 == 0
              ? $r('app.color.common_main_color')
              : $r('app.color.black'))
        }
        .margin({ top: -0.5, left: 2 })
      }
    }
    .height(30)
    .padding({ left: 10, right: 10 })
    .backgroundColor($r('app.color.common_gray_bg'))
    .borderRadius(4)
    .margin({ top: 12, right: this.isNew ? 26 : 10 })
  }
}

