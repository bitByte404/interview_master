import { HcClockIn } from '../commons/components'
import { router } from '@kit.ArkUI'
import { auth, formatTime, req, logger, statusBar, UserInterviewKey, requestClockIn } from '../commons/utils'
import { User } from '../models'
import { AxiosError, AxiosHeaders } from '@ohos/axios'

interface Nav {
  icon: ResourceStr
  name: string
  onClick?: () => void
  other?: string
}

interface Tool {
  icon: ResourceStr
  name: string
  value?: string
  onClick?: () => void
}

@Component
export struct MinePage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @StorageProp(UserInterviewKey)
  user: User = {} as User

  @Builder
  navBuilder(nav: Nav) {
    GridCol() {
      Column() {
        Image(nav.icon)
          .width(30)
          .aspectRatio(1)
          .margin({ bottom: 10 })
        Text(nav.name)
          .fontSize(14)
          .fontColor($r('app.color.common_gray_03'))
          .margin({ bottom: 4 })
        if (nav.other) {
          Row() {
            Text(nav.other)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
            Image($r('sys.media.ohos_ic_public_arrow_right'))
              .width(12)
              .aspectRatio(1)
              .fillColor($r('app.color.common_gray_01'))
          }
        }
      }
      .onClick(() => {
        nav.onClick && nav.onClick()
      })
    }
  }

  @Builder
  toolsBuilder(tool: Tool) {
    Row() {
      Image(tool.icon)
        .width(16)
        .aspectRatio(1)
        .margin({ right: 12 })
      Text(tool.name)
        .fontSize(14)
      Blank()
      if (tool.value) {
        Text(tool.value)
          .fontSize(12)
          .fontColor($r('app.color.common_gray_01'))
      }
      Image($r('sys.media.ohos_ic_public_arrow_right'))
        .width(16)
        .aspectRatio(1)
        .fillColor($r('app.color.common_gray_01'))
    }
    .height(50)
    .width('100%')
    .padding({ left: 16, right: 10 })
    .onClick(() => {
      tool.onClick && tool.onClick()
    })
  }

  build() {
    Column({ space: 16 }) {
      Row({ space: 12 }) {
        Image(this.user.avatar || $r('app.media.ic_mine_avatar'))
          .alt($r('app.media.ic_mine_avatar'))
          .width(55)
          .aspectRatio(1)
          .borderRadius(55)
        // 是否登录 唯一凭证 token
        if (this.user.token) {
          Column({ space: 4 }) {
            Text(this.user.nickName || this.user.username)
              .fontSize(18)
              .fontWeight(500)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Row({ space: 4 }) {
              Text('编辑信息')
                .fontSize(12)
                .fontColor($r('app.color.common_gray_01'))
              Image($r('app.media.ic_mine_edit'))
                .width(12)
                .aspectRatio(1)
                .fillColor($r('app.color.common_gray_01'))
            }
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Start)
        } else {
          Text('立即登录')
            .fontSize(18)
            .fontWeight(500)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
            .onClick(() => {
              router.pushUrl({ url: 'pages/LoginPage' })
            })
        }

        HcClockIn({ clockInCount: this.user.clockinNumbers })
          .onClick(() => {
            requestClockIn()
          })
      }
      .width('100%')
      .height(100)
      .padding({ top: this.topHeight })

      GridRow({ columns: 4 }) {
        this.navBuilder({
          icon: $r('app.media.ic_mine_history'), name: '历史记录', onClick: () => {
            // TODO
          }
        })
        this.navBuilder({
          icon: $r('app.media.ic_mine_collect'), name: '我的收藏', onClick: () => {
            // TODO
          }
        })
        this.navBuilder({
          icon: $r('app.media.ic_mine_like'), name: '我的点赞', onClick: () => {
            // TODO
          }
        })
        this.navBuilder({
          icon: $r('app.media.ic_mine_study'),
          name: '累计学时',
          other: formatTime(this.user.totalTime),
          onClick: () => {
            auth.checkAuth(() => {
              router.pushUrl({
                url: 'pages/StudyTimePage'
              })
            })
          }
        })
      }
      .backgroundColor($r('app.color.white'))
      .padding(16)
      .borderRadius(8)

      Column() {
        this.toolsBuilder({
          icon: $r('app.media.ic_mine_notes'), name: '开发常用词', onClick: () => {
            router.pushUrl({
              url: 'pages/WordPage'
            })
          }
        })
        this.toolsBuilder({
          icon: $r('app.media.ic_mine_ai'), name: '面通AI', onClick: () => {
            router.pushUrl({
              url: 'pages/AudioPage'
            })
          }
        })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_invite'), name: '推荐分享' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_file'), name: '意见反馈' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_info'), name: '关于我们' })
        this.toolsBuilder({
          icon: $r('app.media.ic_mine_setting'), name: '设置', onClick: () => {
            // TODO
          }
        })
      }
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)

      /*      Button('获取用户信息')
              .onClick(() => {
                req.request<User>({
                  url: '/userInfo',
                })
                  .then(res => {
                    logger.info('用户信息成功', JSON.stringify(res))
                  })
                  .catch((error: AxiosError) => {
                    logger.error('用户信息请求失败', JSON.stringify(error))
                  })
              })

            Button('清除用户信息')
              .onClick(() => {
                auth.setUser({} as User)
              })

            Button('修改token-失效')
              .onClick(() => {
                const user = auth.getUser()
                user.token = 'xxx'
                auth.setUser(user)
              })*/
    }
    .padding(16)
    .backgroundColor($r('app.color.common_gray_bg'))
    .linearGradient({
      colors: [['#FFB071', 0], [$r('app.color.common_gray_bg'), 0.3], [$r('app.color.common_gray_bg'), 1]]
    })
    .width('100%')
    .height('100%')
    // 组件切换显示隐藏时触发
    .onVisibleAreaChange([0, 1], (isVisible: boolean) => {
      isVisible ? statusBar.setLightBar() : statusBar.setDarkBar()
    })
  }
}