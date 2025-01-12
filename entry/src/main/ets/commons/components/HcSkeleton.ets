@Component
export struct HcSkeleton {
  @State
  opacityNum: number = 1
  @Builder
  defaultBuilder() {

  }

  @BuilderParam
  default: () => void = this.defaultBuilder

  build() {
    Row({space: 12}) {
      this.default()
    }
    .opacity(this.opacityNum)
    .onAppear(() => {
      this.opacityNum = 0.4
    })
    .animation({
      duration: 600,
      iterations: -1, // 动画次数
      playMode: PlayMode.Alternate
    })
  }
}