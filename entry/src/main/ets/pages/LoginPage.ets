import { HcNavBar } from '../commons/components'
import { promptAction, router } from '@kit.ArkUI'
import { auth, req, tracking } from '../commons/utils'
import { User } from '../models'
import { emitter } from '@kit.BasicServicesKit'
import { LOGIN_EVENT } from '../commons/constants'

interface LoginData {
  username: string
  password: string
}

@Entry
@Component
struct LoginPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  mobile: string = 'hmheima'
  @State
  code: string = 'Hmheima%123'
  @State
  isAgree: boolean = false
  @State
  loading: boolean = false


  async login() {
    // 1. 进行校验
    if (this.mobile.trim() == '') {
      return promptAction.showToast({
        message: '请输入用户名'
      })
    }
    if (this.code.trim() == '') {
      return promptAction.showToast({
        message: '请输入密码'
      })
    }
    if (!this.isAgree) {
      return promptAction.showToast({
        message: '请勾选协议'
      })
    }
    // 2. 发送登录请求
    try {
      // 正在加载，不重复请求
      if (this.loading) return
      this.loading = true // 开启加载中的效果
      const user = await req.request<User, LoginData>({
        url: '/login',
        method: 'post',
        data: {
          username: this.mobile,
          password: this.code
        }
      })
      // 3. 将用户信息存储到AppStorage中
      // AppStorage.setOrCreate<User>('user', user)
      auth.setUser(user)

      // 触发emitter事件，通知首页，开启下拉刷新行为
      emitter.emit(LOGIN_EVENT)

      // 主动上报
      tracking.report(true)

      // 4. 返回个人中心
      // 根据当前业务逻辑 - 选择性的去跳转到某页面
      const params =  router.getParams() as Record<string, string>
      if (params?.return_url) {
        // 回到用户本身想去的页面
        router.replaceUrl({
          url: params.return_url,
          params
        })
      } else {
        router.back()
      }
    } catch (error) {
      // 5. 失败情况处理
      promptAction.showToast({
        message: error.message
      })
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      HcNavBar({ showRightIcon: false })
      Column() {
        Image($r('app.media.icon'))
          .width(120)
          .aspectRatio(1)
        Text('面试通')
          .fontSize(28)
          .margin({ bottom: 15 })
        Text('搞定企业面试真题，就用面试通')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
      }
      .padding(16)

      Column({ space: 15 }) {
        TextInput({ placeholder: '请输入用户名', text: $$this.mobile })
          .customStyle()
        TextInput({ placeholder: '请输入密码', text: $$this.code })
          .type(InputType.Password)
          .showPasswordIcon(false)
          .customStyle()
        Row() {
          Checkbox()
            .shape(CheckBoxShape.ROUNDED_SQUARE)
            .selectedColor('#fa711d')
            .size({ width: 14, height: 14 })
            .select(this.isAgree)
            .onChange((val) => {
              this.isAgree = val
            })
          Text('已阅读并同意')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .padding({ right: 4 })
          Text('用户协议')
            .fontSize(14)
            .padding({ right: 4 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  title: '用户协议',
                  src: 'http://110.41.143.89/user'
                }
              })
            })
          Text('和')
            .fontSize(14)
            .fontColor($r('app.color.common_gray_01'))
            .padding({ right: 4 })
          Text('隐私政策')
            .fontSize(14)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  title: '隐私政策',
                  src: 'http://110.41.143.89/privacy'
                }
              })
            })
        }
        .width('100%')

        Button({ type: ButtonType.Normal }) {
          Row() {
            if (this.loading) {
              LoadingProgress()
                .color($r('app.color.white'))
                .width(24)
                .height(24)
                .margin({ right: 10 })
            }
            Text('立即登录')
              .fontColor($r('app.color.white'))
          }.onClick(() => {
            this.login()
          })
        }
        .width('100%')
        .backgroundColor('none')
        .borderRadius(4)
        .height(44)
        .linearGradient({
          direction: GradientDirection.Right,
          colors: [['#fc9c1c', 0], ['#fa711d', 1]]
        })
        .stateEffect(false)
        .onClick(() => {
          // TODO
        })
      }
      .padding({ left: 36, right: 36, top: 30 })


      Column() {
        Text('其他登录方式')
          .fontSize(14)
          .fontColor($r('app.color.common_gray_01'))
      }
      .padding({ top: 70, bottom: 100 })

    }
    .width('100%')
    .height('100%')
  }
}

@Extend(TextInput)
function customStyle() {
  .placeholderColor('#C3C3C5')
  .caretColor('#fa711d')
  .height(44)
  .borderRadius(0)
  .backgroundColor($r('app.color.white'))
  .border({ width: { bottom: 0.5 }, color: $r('app.color.common_gray_border') })
}