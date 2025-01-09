import { window } from '@kit.ArkUI';
import { Context } from '@kit.AbilityKit';

class StatusBar {
  // 深色文字颜色
  setDarkBar() {
    this.setBar({
      statusBarContentColor: '#000000'
    })
  }

  // 浅色文字颜色
  setLightBar() {
    this.setBar({
      statusBarContentColor: '#ffffff'
    })
  }

  async setBar(config: window.SystemBarProperties) {
    // 1. 获取上下文对象
    const context = AppStorage.get<Context>('context')
    if (context) {
      // 2. 获取窗口
      const win = await window.getLastWindow(context)
      // 3. 设置导航栏状态
      win.setWindowSystemBarProperties(config)
    }
  }
}

export const statusBar = new StatusBar()