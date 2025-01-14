import { auth, req } from "."
import { promptAction, router } from "@kit.ArkUI"

interface ClockInRes {
  clockinNumbers: number
}

export const requestClockIn = async () => {
  // 1. 获取用户信息
  const user = auth.getUser()
  // 2. 判断是否登录
  if (user.token) {
    // 登录态
    if (user.clockinNumbers == 0) {
      // 连续打卡天数为0 -> 未打卡
      promptAction.showToast({
        message: '请打卡'
      })
      const  res = await req.request<ClockInRes>({
        url: '/clockin',
        method: 'post'
      })
      user.clockinNumbers = res.clockinNumbers
      auth.setUser(user)
      promptAction.showToast({message: '打卡成功'})

    } else {
      router.pushUrl({
        url: 'pages/ClockInPage'
      })
    }
  } else {
    // 未登录
    router.pushUrl({
      url: 'pages/LoginPage'
    })
  }
}