import { HcTag } from "."
import { QuestionItem } from "../../models"

@Component
export struct QuestionItemComp {
  @Prop
  item: QuestionItem = {} as QuestionItem

  build() {
    Column({ space: 10 }) {
      Row({ space: 5 }) {
        HcTag({ difficulty: this.item.difficulty })
        Text(this.item.stem)
          .fontSize(15)
          .layoutWeight(1)
          .maxLines(1)
          .fontWeight(500)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
      }
      .width('100%')

      RowSplit() {
        Text('点赞 ' + this.item.likeCount)
          .commonGrayText(true)
        Text('浏览 ' + this.item.views)
          .commonGrayText()
        if (this.item.readFlag) {
          Text('已看过')
            .commonGrayText()
        }
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: 16, right: 15
    })
    .width('100%')
    .height(80)
  }
}

@Extend(Text)
function commonGrayText(isFirst: boolean = false) {
  .fontSize(13)
  .fontColor($r('app.color.common_gray_01'))
  .padding({ left: isFirst ? 0 : 12, right: 12 })
}
