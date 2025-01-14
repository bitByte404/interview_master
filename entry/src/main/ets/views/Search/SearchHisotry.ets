import { history } from "../../commons/utils/History"

interface BtnItem {
  text: string
  onClick?: () => void
}

@Component
export struct SearchHistory {
  @State isDeleting: boolean = false
  @State keywords: string[] = []
  onSearch: (val: string) => void = () => {

  }

  aboutToAppear(): void {
    this.keywords = history.getAll()
  }

  build() {
    // 搜索历史
    Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
      Row() {
        Text('搜索记录')
          .fontSize(15)
          .fontColor($r('app.color.common_gray_01'))
        Blank()
        if (this.isDeleting) {
          Text() {
            Span('全部删除')
              .onClick(() => {
                history.clear()
                this.keywords = history.getAll()
              })
            Span(' | ')
            Span('完成')
              .onClick(() => {
                this.isDeleting = false
              })
          }
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
        } else {
          Image($r('app.media.ic_public_delete'))
            .width(16)
            .aspectRatio(1)
            .fillColor($r('app.color.common_gray_01'))
            .onClick(() => {
              this.isDeleting = true
            })
        }
      }
      .width('100%')

      ForEach(this.keywords, (keyword: string) => {
        Row({ space: 8 }) {
          Text(keyword)
            .fontSize(14)
            .fontColor('#6F6F6F')
          if (this.isDeleting) {
            Image($r('app.media.ic_public_close'))
              .width(12)
              .aspectRatio(1)
              .fillColor('#878787')
              .onClick(() => {
                history.delItem(keyword)
                this.keywords =  history.getAll()
              })
          }
        }
        .padding({ left: 12, right: 12 })
        .height(32)
        .backgroundColor('#f3f4f5')
        .borderRadius(16)
        .margin({ right: 16, top: 16 })
        .onClick(() => {
          if (!this.isDeleting) {
            // 非编辑态才可点击搜索
            this.onSearch(keyword)
          }
        })
      })
    }
    .padding(16)
  }
}