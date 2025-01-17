import { ProjectType, StudyTimeItem } from '../../models'

@Component
export struct ProjectsItemComp {
  @Prop item: ProjectType = {} as ProjectType
  @Prop studyTime: StudyTimeItem = {} as StudyTimeItem

  build() {
    Row() {
      Image(this.item.icon)
        .height(80)
      Column() {
        Text(this.item.name)
          .fontWeight(500)
          .fontSize(14)
        Column() {
          Text() {
            Span(`${this.studyTime.done}`)
              .fontColor($r('app.color.common_blue'))
            Span(`/${this.studyTime.total}节 | 已学进度 ${(this.studyTime.done / this.studyTime.total *
              100).toFixed(0)}%`)
          }
          .fontWeight(400)
          .fontSize(12)
          .fontColor($r('app.color.common_gray_01'))

          Text()
            .width('100%')
            .height(2)
            .backgroundColor($r('app.color.home_gray'))
        }
        .height(20)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding(10)
      .justifyContent(FlexAlign.SpaceBetween)
      .height('100%')
    }
    .height(96)
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({
      left: 7,
      right: 7,
      top: 8,
      bottom: 8
    })
    .borderRadius(9.5)
  }
}