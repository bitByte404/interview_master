import { logger } from '../commons/utils'

@Entry
@Component
struct Index {
  build() {
    Column({ space: 20 }) {
      Button('hilog.info测试')
        .onClick(() => {
          // hilog.info(0x0000, 'myhilog', '%{public}s ---- %{public}s', '第一个参数', '第二个参数')
          logger.info('第一个参数 ', '第二个参数')
        })
      Button('hilog.warn测试')
        .onClick(() => {
          // hilog.warn(0x0000, 'myhilog', '%{public}s ---- %{public}s', '第一个参数', '第二个参数')
          logger.warn('第一个参数 ', '第二个参数')
        })
      Button('hilog.debug测试')
        .onClick(() => {
          // hilog.debug(0x0000, 'myhilog', '%{public}s ---- %{public}s', '第一个参数', '第二个参数')
          logger.debug('第一个参数 ', '第二个参数')
        })
      Button('hilog.error测试')
        .onClick(() => {
          // hilog.error(0x0000, 'myhilog', '%{public}s ---- %{public}s', '第一个参数', '第二个参数')
          logger.error('第一个参数 ', '第二个参数')
        })
    }
    .width('100%')
    .height('100%')
  }
}