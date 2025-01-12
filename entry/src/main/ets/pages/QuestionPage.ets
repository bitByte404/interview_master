@Entry
@Component
struct QuestionPage {
  @State message: string = '试题详情';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('QuestionPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}