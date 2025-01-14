import { preferences } from '@kit.ArkData'
import { promptAction } from '@kit.ArkUI'


@Entry
@Component
struct TestPage {
  store?: preferences.Preferences
  KEY: string = 'user'

  // 初始化首选项实例
  // Sync 同步获取
  async aboutToAppear() {
    const context = getContext(this)
    this.store = await preferences.getPreferences(context, { name: 'test-store' })

  }

  build() {
    Column({ space: 20 }) {
      Button('添加')
        .onClick(() => {
          this.store?.putSync(this.KEY, '阿伟')
          // 持久化
          this.store?.flush()
        })
      Button('获取')
        .onClick(() => {
          const data = this.store?.getSync(this.KEY, '')
          promptAction.showToast({message: data + ''})
        })
      Button('修改')
        .onClick(() => {
          this.store?.putSync(this.KEY, 'hhhhhhhh')
          // 持久化
          this.store?.flush()
        })
      Button('删除')
        .onClick(() => {
          this.store?.deleteSync(this.KEY)
          // 持久化
          this.store?.flush()
        })
    }
    .width('100%')
    .padding({ top: 60 })
  }
}