import { window } from '@kit.ArkUI'
import { Context } from '@kit.AbilityKit'
import { logger } from '.'

// context 应用上下文，应用提供的一些功能对象
// 1. 组件中 getContext(this) 获取this组件实例，如果在非组件中，获取的是undefined
// 2. 在Ability中 this.context 获取上下文对象
class FullScreen {
  // 开启全屏
  async enable() {
    // 先获取上下文对象
    const context = AppStorage.get<Context>('context')
    if (context) {
      // 获取应用窗口
      const win = await window.getLastWindow(context)
      // 开启沉浸式效果 - 开启全屏效果
      await win.setWindowLayoutFullScreen(true) // 添加await，完成之后再进行后续操作
      const topArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      //  5. 存储顶部状态栏的高度 默认获取的高度单位是px
      // px2vp() -> 将px单位的数值 -> vp单位 精准
      AppStorage.setOrCreate('topHeight', px2vp(topArea.topRect.height))
      // 6. 获取底部区域
      const bottomArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      AppStorage.setOrCreate('bottomHeight', px2vp(bottomArea.bottomRect.height))
    }
  }


  // 关闭全屏
  async disable() {
    // 先获取上下文对象
    const context = AppStorage.get<Context>('context')
    if (context) {
      // 获取应用窗口
      const win = await window.getLastWindow(context)
      // 关闭沉浸式效果 - 关闭全屏效果
      await win.setWindowLayoutFullScreen(false)
      // px2vp() -> 将px单位的数值 -> vp单位 精准
      AppStorage.setOrCreate('topHeight', 0)
      AppStorage.setOrCreate('bottomHeight', 0)
    }
  }
}

export const fullScreen = new FullScreen()