@Component
export  struct HcSkeletonItem {
  @Prop
  widthValue: Length = '100%'
  build() {
    Text()
      .height(16)
      .width(this.widthValue)
      .borderRadius(2)
      .backgroundColor($r('app.color.common_gray_bg'))
  }
}