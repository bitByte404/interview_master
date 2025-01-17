import { ConfigurationConstant } from "@kit.AbilityKit"
import { theme, ThemeKey } from "../../commons/utils/Theme"

@CustomDialog
export struct SettingsThemeDialog {
  controller: CustomDialogController
  @StorageProp(ThemeKey)
  colorMode: ConfigurationConstant.ColorMode
    = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT

  build() {
    Column() {
      Row() {
        Column({ space: 4 }) {
          Text('跟随系统')
          Text('开启后，将跟随系统打开或关闭深色模式')
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
        }
        .alignItems(HorizontalAlign.Start)

        Toggle({
          type: ToggleType.Switch,
          isOn: this.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET
        })
          .onChange((val) => {
            if (val) {
              theme.notSet()
            } else {
              theme.light()
            }
          })
      }
      .width('100%')
      .height(70)
      .justifyContent(FlexAlign.SpaceBetween)
      .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })

      if (this.colorMode != ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
        Row() {
          Text('普通模式')
            .fontSize(15)
          Blank()
          if (this.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
            Image($r('app.media.ic_public_ok'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_green'))
          }
        }
        .width('100%')
        .height(50)
        .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })
        .onClick(() => {
          theme.light()
        })

        Row() {
          Text('深色模式')
            .fontSize(15)
          Blank()
          if (this.colorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
            Image($r('app.media.ic_public_ok'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_green'))
          }
        }
        .width('100%')
        .height(50)
        .onClick(() => {
          theme.dark()
        })

      }
    }
    .padding({
      top: 15,
      bottom: 15,
      left: 30,
      right: 30
    })
    .backgroundColor($r('app.color.white'))
  }
}