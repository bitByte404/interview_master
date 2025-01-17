@Component
export  struct HcSkeletonItem {
  @Prop
  widthValue: Length = '100%'
  @Prop
  heightValue: Length = '16'
  build() {
    Text()
      .height(this.heightValue)
      .width(this.widthValue)
      .borderRadius(2)
      .backgroundColor($r('app.color.common_gray_bg'))
  }
}