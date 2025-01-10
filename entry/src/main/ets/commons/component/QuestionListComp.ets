import { QuestionItemComp } from "."
import { PageData, QuestionItem, QuestionListParams, SortType } from "../../models"
import { http } from "../utils"
import { promptAction } from "@kit.ArkUI"

@Component
export struct QuestionListComp {
  @State isRefreshing: boolean = false
  // 是否完成加载
  @State isFinished: boolean = false
  // 正在加载中
  @State isLoading: boolean = false
  // 列表数据
  @State list: QuestionItem[] = []
  // 试题分类id
  @Prop typeId: number
  // 试题列表排序规则
  @Prop sort: SortType = SortType.Default
  @State page: number = 1

  // onRefreshing =>  模拟1后更新状态 完成
  async onRefresh() {
    this.page = 1 // 重置页码
    const res = await this.getQuestionList()
    this.list = res.rows
    this.isLoading = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.isFinished = false
      this.page++
    }
    this.isRefreshing = false
    promptAction.showToast({ message: `数据更新成功` })
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
        ForEach(this.list, (item: QuestionItem, index) => {
          ListItem() {
            QuestionItemComp({ item })
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

  // 加载试题列表
  async onLoad() {
    const res = await this.getQuestionList()
    this.list.push(...res.rows)
    this.isLoading = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.page++
    }
  }

  getQuestionList(): Promise<PageData<QuestionItem>> {
    return http.request<PageData<QuestionItem>>({
      url: '/question/list',
      params: {
        type: this.typeId,
        sort: this.sort,
        questionBankType: 10,
        pageSize: 10, // 每页条数
        page: this.page
      } as QuestionListParams
    })
  }
}