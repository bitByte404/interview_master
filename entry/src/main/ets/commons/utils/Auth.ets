import { User } from "../../models"
import { promptAction, router } from "@kit.ArkUI"

export const UserInterviewKey = 'interview-user'

class Auth {
  initUser() {
    PersistentStorage.persistProp<User>(UserInterviewKey, {} as User)
  }

  getUser(): User {
    return AppStorage.get(UserInterviewKey) || {} as User
  }

  setUser(user: User) {
    AppStorage.setOrCreate(UserInterviewKey, user)
  }

  // 访问权限控制
  checkAuth(options: router.RouterOptions | Function) {
    const user = this.getUser()
    // 1. 根据是否有token判断 是否有权限
    // 2.两种情况
    // 2.1 路由跳转
    // 跳转前检查token，如果没有token，
    // 则跳转到登录页面并需要携带登录后回调的页面地址
    if (user.token) {
      // token存在，该干嘛干嘛
      if (typeof options == 'function') {
        options()
        return
      }
      router.pushUrl(options)
    } else {
      // 2.2 点击按钮
      // 点击按钮，触发点击处理函数判断token是否存在，如果没有，跳转登录，返回即可
      if (typeof options == 'function') {
        router.pushUrl({
          url: 'pages/LoginPage'
        })
        return
      }
      // 跳转到登录页 -> 携带登录成功后回调的页面地址
      const params = (options.params || {}) as Record<string, string>;
      params.return_url = options.url
      router.pushUrl({
        url: 'pages/LoginPage',
        params
      })
      promptAction.showToast({
        message: '用户未登录'
      })
    }
  }
}

export const auth = new Auth()