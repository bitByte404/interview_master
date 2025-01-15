import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit'

class Permission {
  // 请求用户授权
  async requestPermissions(permissionList: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager()
    const context = AppStorage.get<Context>('context')
    if (context) {
      const result = await atManager.requestPermissionsFromUser(context, permissionList)
      return result.authResults.every(item => item == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    }
    return false // 未授权
  }

  // 打开权限设置
  async requestPermissionSetting(permissionList: Permissions[]) {
    const atManager = abilityAccessCtrl.createAtManager()
    const context = AppStorage.get<Context>('context')
    if (context) {
      const authResults = await atManager.requestPermissionOnSetting(context, permissionList)
      return authResults.every(item => item == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    }
    return false // 未授权
  }
}

export const permission = new Permission()