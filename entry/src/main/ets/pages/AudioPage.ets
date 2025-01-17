import { Permissions } from '@kit.AbilityKit';
import { permission } from '../commons/utils';
import { promptAction, router } from '@kit.ArkUI';
import { AudioView } from '../views/Audio/AudioView';


@Entry
@Component
struct AudioPage {
  permissions: Permissions[] = ['ohos.permission.MICROPHONE']

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
    Column()  {
      AudioView()
    }
    .height('100%')
    .width('100%')
  }
}