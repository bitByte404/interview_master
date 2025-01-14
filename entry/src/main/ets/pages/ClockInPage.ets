import { HcLoadingDialog, HcNavBar } from '../commons/components'
import { HmCalendar, HmCalendarSelectedDay } from '@ohmos/calendar'
import { req } from '../commons/utils'
import { ClockInfo, ClockInfoParams } from '../models'

interface DayBuilderParams {
  day: number
  text: string
}

@Entry
@Component
struct ClockInPage {
  // 页面打卡相关信息
  @State clockInfo: ClockInfo = {
    flag: false,
    clockinNumbers: 0,
    totalClockinNumber: 0,
    clockins: []
  }
  @State selectedDays: HmCalendarSelectedDay[] = []

  dialog = new CustomDialogController({
    builder: HcLoadingDialog(),
    // 自定义弹窗样式
    customStyle: true,
  })

  @Builder
  dayBuilder(params: DayBuilderParams) {
    Column() {
      Row() {
        Text(params.day.toString())
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Text('天')
          .fontSize(10)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ bottom: 8, left: 10 })
      }
      .alignItems(VerticalAlign.Bottom)

      Text(params.text)
        .fontSize(10)
        .fontColor($r('app.color.common_gray_01'))
    }.margin({ right: 36 })
  }

  aboutToAppear(): void {
    const current = new Date()
    current.getMonth() + 1
    current.getFullYear()
    this.getClockInfo({
      year: current.getFullYear().toString(),
      month: (current.getMonth() + 1).toString()
    })
  }

  async getClockInfo(params: ClockInfoParams) {
    this.dialog.open()
    const res = await req.request<ClockInfo>({
      url: '/clockinInfo',
      params
    })
    this.dialog.close()
    this.clockInfo = res
    // this.selectedDays = res.clockins.map(item => {
    //   return { date: item.createdAt } as HmCalendarSelectedDay
    // })
    this.selectedDays = res.clockins.map(item => ({ date: item.createdAt } as HmCalendarSelectedDay))
  }

  onPageHide(): void {
    this.dialog.close()
  }

  build() {
    Column({ space: 16 }) {
      HcNavBar({ title: '每日打卡', showRightIcon: false })
      Row() {
        this.dayBuilder({ day: this.clockInfo.totalClockinNumber, text: '累计打卡' })
        this.dayBuilder({ day: this.clockInfo.clockinNumbers, text: '连续打卡' })
      }
      .padding({
        top: 10,
        bottom: 25,
        left: 16,
        right: 16
      })
      .width('100%')
      .justifyContent(FlexAlign.Start)

      Row() {
        Row() {
          HmCalendar({
            color: '#00aa00',
            selectedDays: this.selectedDays,
            onChangeMonth: (month) => {
              const dateArr = month.split('-')
              this.getClockInfo({
                year: dateArr[0],
                month: dateArr[1]
              })
            }
          })
            .borderRadius(8)
            .border({ width: 0.5, color: '#ededed' })
            .shadow({ color: '#ededed', radius: 16 })
        }
        .width('100%')
        .height(350)
        .borderRadius(8)
        .border({ width: 0.5, color: '#ededed' })
        .shadow({ color: '#ededed', radius: 16 })
        .backgroundColor($r('app.color.white'))
      }
      .padding({ left: 16, right: 16 })

    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.clocked_bg'))
    .backgroundImageSize({ width: '100%' })
  }
}