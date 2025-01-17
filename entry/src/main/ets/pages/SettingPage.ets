import { promptAction, router } from '@kit.ArkUI';
import { HcNavBar } from '../commons/components';
import { auth } from '../commons/utils/Auth';
import { User } from '../models';
import { SettingsThemeDialog } from '../views/Settings/SettingsThemeDialog';
import { fileIo, storageStatistics } from '@kit.CoreFileKit';
import { bundleManager } from '@kit.AbilityKit';

export interface Tool {
  icon?: ResourceStr
  name: string
  value?: string
  onClick?: () => void,
  radius?: 0 | 1 | 2
}

@Entry
@Component
struct SettingsPage {
  dialog = new CustomDialogController({
    builder: SettingsThemeDialog(),
    alignment: DialogAlignment.Bottom,
  })
  @StorageProp('isDark')
  isDark: boolean = false
  @State cacheSize: string = '0.00MB'
  @State version: string = ''

  @Builder
  toolsBuilder(tool: Tool) {
    Row() {
      if (tool.icon) {
        Image(tool.icon)
          .width(16)
          .aspectRatio(1)
          .margin({ right: 12 })
      }
      Text(tool.name)
        .fontSize(16)
      Blank()
      if (tool.value) {
        Text(tool.value)
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ right: 10 })
      }
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(18)
        .aspectRatio(1)
        .fillColor($r('app.color.common_gray_01'))
    }
    .height(50)
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: 16, right: 10 })
    .borderRadius({
      topLeft: tool.radius === 1 ? 8 : 0,
      topRight: tool.radius === 1 ? 8 : 0,
      bottomLeft: tool.radius === 2 ? 8 : 0,
      bottomRight: tool.radius === 2 ? 8 : 0
    })
    .onClick(() => {
      tool.onClick && tool.onClick()
    })
  }

  onPageShow(): void {
    this.calcCache()
  }

  async calcCache() {
    const result = await storageStatistics.getCurrentBundleStats()
    this.cacheSize = (result.cacheSize / 1024 / 1024).toFixed(2) + 'MB'
  }

  async clearCache() {
    // 清除缓存文件
    // 当前包下
    const ctx = getContext(this)
    const cacheDir = ctx.cacheDir
    // 判断是否可以访问该文件
    const isExist = fileIo.accessSync(cacheDir)
    if (isExist) {
      fileIo.rmdirSync(cacheDir)
    }
    // 应用下
    const appCtx = ctx.getApplicationContext()
    const appCacheDir = appCtx.cacheDir
    const isAppExist = fileIo.accessSync(appCacheDir)
    if (isAppExist) {
      fileIo.rmdirSync(appCacheDir)
    }
    this.calcCache()
  }

  async getVersion() {
    const res = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    this.version = 'v' + res.versionName
  }

  aboutToAppear(): void {
    this.getVersion()
  }

  build() {
    Column() {
      HcNavBar({ title: '设置', showRightIcon: false, showBorder: true })
      Column({ space: 0.5 }) {
        Blank()
          .height(15)
        this.toolsBuilder({
          name: '编辑资料', radius: 1, onClick: () => {
            auth.checkAuth({
              url: 'pages/ProfilePage'
            })
          }
        })
        this.toolsBuilder({ name: '账号设置', radius: 2 })
        Blank()
          .height(15)
        this.toolsBuilder({ name: '消息推送', radius: 1 })
        this.toolsBuilder({
          name: '深色模式',
          value: this.isDark ? '已开启' : '已关闭',
          radius: 1,
          onClick: () => {
            this.dialog.open()
          }
        })
        this.toolsBuilder({
          name: '清除应用缓存', value: this.cacheSize, onClick: () => {
            this.clearCache()
            promptAction.showToast({
              message: '清理缓存成功'
            })
          }
        })
        this.toolsBuilder({ name: '当前版本', value: this.version , radius: 2 })
        Blank()
          .height(15)
        Text('退出账号')
          .height(50)
          .fontColor($r('app.color.common_main_color'))
          .opacity(0.6)
          .onClick(async () => {
            auth.setUser({} as User)
            router.back()
          })
      }
      .layoutWeight(1)
      .padding({ right: 15, left: 15 })
      .backgroundColor($r('app.color.common_gray_bg'))
    }
  }
}