import { abilityAccessCtrl, common, Permissions, Want } from '@kit.AbilityKit';
import { logger, permission } from '../commons/utils';
import { promptAction, router } from '@kit.ArkUI';


@Entry
@Component
struct AudioPage {
  @State message: string = 'Hello World';
  permissions: Permissions[] = ['ohos.permission.MICROPHONE']

  /**
   * 目标：麦克风授权 - 授权提示框 + 开启权限设置面板
   * 授权提示框：
   * 1. module.json5配置权限 - 针对于用户敏感权限
   *    name + reason + usedScene 权限名称 + 授权理由 + 使用场景
   *
   * 2. abilityAccessControl.createAtManager 索要权限
   * 3. 创建权限管理对象
   * 4. 弹窗授权窗口
   * 5. 判断是否授权
   */

  aboutToAppear(): void {
    this.getPermission()
  }

  async getPermission() {
    try {
      // 第一次授权
      const isAuth = await permission.requestPermissions(this.permissions)
      if (!isAuth) {
        const confirm = await promptAction.showDialog({
          title: '温馨提示',
          message: '未授权使用麦克风将无法使用该面试录音功能，是否前往设置进行授权？',
          buttons: [{ text: '离开', color: $r('app.color.common_gray_01') },
            { text: '去授权', color: $r('app.color.black') }]
        })
        if (confirm.index == 1) {
          // 二次授权
          const isAgainAuth = await permission.requestPermissionSetting(this.permissions)
          if (isAgainAuth) {
            return
          }
        }
        router.back()
      }
    } catch (err) {
      // 点击弹窗外关闭弹窗会返回错误的promise
      router.back()
    }
  }

  build() {
    Column({ space: 50 }) {
      Button('打开设置页')
        .onClick(() => {
          let want: Want = {
            bundleName: 'com.huawei.hmos.settings',
            abilityName: 'com.huawei.hmos.settings.MainAbility',
            uri: 'application_info_entry',
            parameters: {
              pushParams: 'com.example.interview_master'
            }
          }
          const context = getContext(this) as common.UIAbilityContext
          context.startAbility(want)
        })
    }
    .padding(50)
    .height('100%')
    .width('100%')
  }
}