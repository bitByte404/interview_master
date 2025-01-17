import { common, ConfigurationConstant } from "@kit.AbilityKit"

export const ThemeKey = 'hc-theme-key'

class Theme {
  // 1. 初始化主题 (根据设置保存的主题模式，更新当前应用的主题模式)
  initTheme() {
    // 初始化
    PersistentStorage.persistProp<ConfigurationConstant.ColorMode>(ThemeKey, ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
    // 获取用户设置的主题
    const colorMode = AppStorage.get<ConfigurationConstant.ColorMode>(ThemeKey)
    this.setTheme(colorMode!)
  }

  // 2. 设置跟随系统主题
  notSet() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
  }

  // 3. 设置普通/日间模式
  light() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }
  // 4. 设置暗黑/深色模式
  dark() {
    this.setTheme(ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
  }

  private setTheme(colorMode: ConfigurationConstant.ColorMode) {
    AppStorage.set(ThemeKey, colorMode)
    const ctx = AppStorage.get<Context>('context')
    if (ctx) {
      ctx.getApplicationContext().setColorMode(colorMode)
    }
    // 获取当前应用采用的颜色模式
    const isDark = (ctx as common.UIAbilityContext).config.colorMode
      == ConfigurationConstant.ColorMode.COLOR_MODE_DARK
    AppStorage.setOrCreate('isDark', isDark)
  }
}
export const theme = new Theme()