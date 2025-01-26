import { InterviewItem } from "../../models"

@Component
export  struct InterviewItemComp {
  @Prop item: InterviewItem
  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.ic_mine_logo'))
            .width(25)
            .margin({
              right: 10
            })
          Text(`面经 | ${this.item.stem}`)
            .fontSize(14.4)
            .fontWeight(500)
        }
        .margin({bottom: 10})

        Text(this.item.content)
          .fontSize(13.4)
          .fontWeight(400)
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .margin({bottom: 10})
          .width('100%')
          .fontColor($r('app.color.common_gray_02'))
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      Row() {
        Text() {
          Span(`点赞 ${this.item.likeCount} | `)
          Span(`浏览 ${this.item.views} | `)
          ImageSpan($r('app.media.icon_share'))
            .height(14)
            .margin({left: 5})
        }
        .fontWeight(400)
        .fontSize(11.5)
        .fontColor($r('app.color.common_gray_01'))
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      top: 17,
      left: 14.4,
      right: 14.4,
      bottom: 14.4
    })
    .height(100)
    .alignItems(HorizontalAlign.Start)
  }
}