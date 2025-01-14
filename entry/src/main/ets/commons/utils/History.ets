import { preferences } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'

class History {
  store: preferences.Preferences | null = null

  private getStore() {
    if (!this.store) {
      const context = AppStorage.get<Context>('context')
      const store = preferences.getPreferencesSync(context, { name: 'history-store' })
      this.store = store
    }
    return this.store
  }

  // 存储单条历史
  setItem(keyword: string) {
    this.getStore().putSync(keyword, keyword)
    this.getStore().flush()
  }

  // 删除单条历史
  delItem(keyword: string) {
    this.getStore().deleteSync(keyword)
    this.getStore().flush()
  }

  // 获取所有历史
  getAll() {
    const obj = this.getStore().getAllSync()
    return Object.keys(obj)
  }

  // 清除所有历史
  clear() {
    this.getStore().clearSync()
    this.getStore().flush()
  }
}

export const history = new History()

