import { auth, req } from "../../commons/utils"
import { InterviewData, InterviewItem, QuestionListParams, SortType } from "../../models"
import { InterviewItemComp } from "./InterviewItemComp"
@Component
export struct InterviewListComp {
  @State isRefreshing: boolean = false
  @State isFinished: boolean = false
  @State isLoading: boolean = false
  // 列表数据
  @State list: InterviewItem[] = []
  // 试题分类id
  @Prop typeId: number
  // 试题列表排序规则
  @Prop
  @Watch('changeSort')
  sort: SortType = SortType.Default
  @State page: number = 1
  @Prop keyword: string // 查询关键字

  changeSort() {
    this.isRefreshing = true
  }

  async onRefresh() {
    this.page = 1
    const res = await this.getInterviewList()
    this.list = res.rows
    this.isLoading = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else {
      this.isFinished = false
      this.page++
    }
    this.isRefreshing = false
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
    Refresh({refreshing: $$this.isRefreshing}) {
      List() {
        ForEach(this.list, (item: InterviewItem, index) => {
          ListItem() {
            InterviewItemComp({item})
              .onClick(() => {
                // TODO 跳转面经详情
                auth.checkAuth({
                  url: 'pages/InterviewDetailPage',
                  params: item
                })
              })
          }
        })
        this.loadMoreBuilder()
      }
      .onReachEnd(() => {
        if (this.isLoading || this.isFinished || this.isRefreshing) return
        this.isLoading = true
        this.onLoad()
      })
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth: 0.5,
        color: $r('app.color.common_gray_border'),
        startMargin: 16,
        endMargin: 16
      })
    }
    .onRefreshing(() => {
      this.onRefresh()
    })
  }

  async onLoad() {
    const res = await this.getInterviewList()
    this.list.push(...res.rows)
    this.isLoading = false
    if (this.page >= res.pageTotal) {
      this.isFinished = true
    } else  {
      this.page++
    }
  }

  getInterviewList(): Promise<InterviewData> {
    return req.request<InterviewData>({
      url: '/question/list',
      params: {
        type: this.typeId,
        sort: this.sort,
        questionBankType: 9,
        pageSize: 10, // 每页条数
        page: this.page,
        keyword: this.keyword
      } as QuestionListParams
    })
  }
}

