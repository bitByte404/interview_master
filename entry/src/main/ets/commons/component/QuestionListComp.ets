import { QuestionItemComp } from "."
import { QuestionItem } from "../../models"

@Component
export struct QuestionListComp {
  @State isRefreshing: boolean = false
  // 是否完成加载
  @State isFinished: boolean = false
  // 正在加载中
  @State isLoading: boolean = false
  // 列表数据
  @State list: QuestionItem[] = []

  // onRefreshing =>  模拟1后更新状态 完成
  onRefresh() {
    setTimeout(() => {
      this.list = []
      for (let i = 0; i < 10; i++) {
        this.list.push({} as QuestionItem)
      }
      this.isRefreshing = false
      this.isFinished =  false
    }, 1000)
  }

  @Builder
  loadMoreBuilder() {
    ListItem() {
      // 判断当前加载状态 - 加载中 / 加载完成
      if (this.isFinished) {
        Row() {
          Text('没有更多了')
            .fontSize(15)
            .fontColor($r('app.color.common_gray_03'))
        }.width('100%')
        .justifyContent(FlexAlign.Center)
      } else if (this.isLoading) {
        Row({ space: 5 }) {
          LoadingProgress()
            .width(20)
          Text('正在加载中')
            .fontSize(15)
            .fontColor($r('app.color.common_gray_03'))
        }.width('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .height(80)
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        ForEach(this.list, () => {
          ListItem() {
            QuestionItemComp({
              item: {
                id: '1',
                stem: '如何删除Record中的元素',
                difficulty: 3,
                likeCount: 100,
                views: 65,
                readFlag: 1
              }
            })
          }
        })

        this.loadMoreBuilder()
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None) // 关闭回弹效果
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_border'),
        startMargin: 16,
        endMargin: 16
      })
      .onReachEnd(() => {
        // 每次触底之后，先开启loading效果
        if (this.isLoading || this.isFinished || this.isRefreshing) {
          // 当前状态为加载中、已加载完成，下拉刷新中
          // 有任何一个状态符合的话，终止代码继续执行
          return
        }
        this.isLoading = true
        this.onLoad()
      })
    }
    .width('100%')
    .height('100%')
    .onRefreshing(() => {
      this.onRefresh()
    })
  }

  // 加载逻辑代码
  onLoad() {
    setTimeout(() => {
      for (let i = 0; i < 10; i++) {
        this.list.push({

        } as QuestionItem)
      }
      this.isLoading = false
      // 列表长度40， 终止加载
      if (this.list.length >= 40) {
        this.isFinished = true
      }
    }, 1000)
  }
}