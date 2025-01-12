import { auth } from '../commons/utils/Auth'
import { HomePage } from './HomePage'
import { InterviewPage } from './InterviewPage'
import { MinePage } from './MinePage'
import { ProjectPage } from './ProjectPage'

interface TabItem {
  icon: Resource
  activeIcon: Resource
  name: string
}

// 初始化用户信息
auth.initUser()

@Entry
@Component
struct Index {
  @State activeIndex: number = 0
  // struct Index 数据
  tabList: TabItem[] = [
    {
      icon: $r('app.media.tabbar_home'),
      activeIcon: $r('app.media.tabbar_home_fill'),
      name: '首页'
    },
    {
      icon: $r('app.media.tabbar_project'),
      activeIcon: $r('app.media.tabbar_project_fill'),
      name: '项目'
    },
    {
      icon: $r('app.media.tabbar_interview'),
      activeIcon: $r('app.media.tabbar_interview_fill'),
      name: '面经'
    },
    {
      icon: $r('app.media.tabbar_mine'),
      activeIcon: $r('app.media.tabbar_mine_fill'),
      name: '我的'
    }
  ]
  @StorageProp('bottomHeight')
  bottomHeight: number = 0
  @Builder
  TabBarBuilder(item: TabItem, index: number) {
    Column({ space: 5 }) {
      Image(this.activeIndex === index ? item.activeIcon : item.icon)
        .fillColor('#41B883')
        .width(24)
        .aspectRatio(1)
      Text(item.name)
        .fontSize(12)
        .fontColor(this.activeIndex == index ? $r('app.color.black') : $r('app.color.common_gray_01'))
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(this.tabList, (item: TabItem, index) => {
          TabContent() {
            if (index == 0) {
              HomePage()
            } else if (index == 1) {
              ProjectPage()
            } else if (index == 2) {
              InterviewPage()
            } else if (index == 3) {
              MinePage()
            }
          }
          .layoutWeight(1)
          .tabBar(this.TabBarBuilder(item, index))
        })

      }
      .onTabBarClick((index) => {
        this.activeIndex = index
      })
      .scrollable(false)
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_border') })
    }
    .width('100%')
    .height('100%')
    .padding({
      bottom: this.bottomHeight
    })
    .backgroundColor($r('app.color.white'))
  }
}