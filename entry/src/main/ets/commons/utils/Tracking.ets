import { logger, req } from '.'
import { TimeItem } from '../../models'
import { preferences } from '@kit.ArkData'
import { Context } from '@kit.AbilityKit'
import { JSON } from '@kit.ArkTS'


class Tracking {
  store: preferences.Preferences | null = null
  dataKey: string = 'time-list'

  /**
   * 获取首选项实例 - 只会初始化一次
   */
  getStore() {
    if (!this.store) {
      const context = AppStorage.get<Context>('context')
      const store =  preferences.getPreferencesSync(context, { name: 'tracking-store' })
      this.store = store
    }
    return this.store
  }

  // 记录 埋点数据
   record(startTime: number, endTime: number, questionId: string) {
    // 使用preference优化埋点上报逻辑 防止频繁切换页面频繁上报
    const store = this.getStore()
    const jsonStr = store?.getSync(this.dataKey, '[]')
    const timeList = JSON.parse(jsonStr as string) as TimeItem[]
    timeList.push({
      startTime,
      endTime,
      questionId
    })
    logger.warn('tracking', JSON.stringify(timeList))
    store?.putSync(this.dataKey, JSON.stringify(timeList))
    store?.flush()
  }

  // 上报 埋点数据
  // force: 是否主动上报
  async report(force: boolean = false) {
    // 1. 先从首选项实例中获取数据
    // 2. 再将json转成数组
    // 3. 提交数据
    // 4. 删除数据并持久化
    const json = this.getStore().getSync(this.dataKey, '[]')
    const list = JSON.parse(json.toString()) as TimeItem[]
    // 主动上报 list.length > 0 && 登录成功 或者进入首页 --> 主动上报
    // 数据长度大于5再上报
    if (list.length >= 5 || (list.length > 0 && force)) {
      await req.request<null>({
        url: '/time/tracking',
        method: 'post',
        data: {
          timeList: list
        }
      })
      this.getStore().deleteSync(this.dataKey)
      this.getStore().flush()
    }
  }
}

export const tracking = new Tracking()