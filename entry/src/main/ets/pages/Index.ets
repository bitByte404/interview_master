@Entry
@Component
struct Index {

  build() {
    Column() {
      Text('Hello world')
        .fontColor($r('app.color.common_green'))
        .fontSize(50)
    }
    .width('100%')
    .height('100%')
  }
}