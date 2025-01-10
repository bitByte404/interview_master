@Component
@Preview
export struct HcClockIn {
  @Prop clockInCount: number = 0

  build() {
    Row() {
      if (this.clockInCount > 0) {
        Column() {
          Text('已连续打卡')
            .fontSize(8)
          Text(this.clockInCount + ' 天')
            .fontSize(12)
        }
        .offset({top: 2})
      } else {
        Text('打卡')
          .fontSize(10)
          .offset({
            top: 2
          })
      }
    }
    .width(74)
    .height(28)
    .backgroundImage(
      this.clockInCount > 0
      ? $r('app.media.ic_common_clocked') :
    $r('app.media.ic_common_unclock'))
    .padding({left: 32})
  }
}