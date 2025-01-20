@Component
export struct InterviewListComp {
  build() {
    List() {
      ForEach([1, 1, 2, 3, 4, 5, 6, 7], (item: number, index) => {
        ListItem() {
          Column() {
            Column() {
              Row() {
                Image($r('app.media.ic_mine_logo'))
                  .width(25)
                  .margin({
                    right: 10
                  })
                Text('面经 | 2021美团3面经验总结')
                  .fontSize(14.4)
                  .fontWeight(500)
              }
              .margin({bottom: 10})

              Text('这是我写的面经正文，函数限制2行，超出两这是我写的面经正文，函数限制2行，超出两')
                .fontSize(13.4)
                .fontWeight(400)
                .maxLines(1)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .width('100%')
                .fontColor($r('app.color.common_gray_02'))
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            Row() {
              Text() {
                Span('点赞 10 | ')
                Span('浏览 10 | ')
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
      })
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
  }
}

