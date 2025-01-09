import { statusBar } from '../commons/utils/StatusBar'

@Entry
@Component
struct Index {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp('bottomHeight')
  bottomHeight: number = 0

  build() {
    Column() {
      Text('top')
      Button('浅色文字切换')
        .onClick(() => {
          statusBar.setLightBar()
        })
      Button('深色文字切换')
        .onClick(() => {
          statusBar.setDarkBar()
        })
      Blank()
      Text('bottom')
    }
    .width('100%')
    .backgroundColor(Color.Red)
    .height('100%')
    .padding({
      top: this.topHeight,
      bottom: this.bottomHeight
    })
  }
}