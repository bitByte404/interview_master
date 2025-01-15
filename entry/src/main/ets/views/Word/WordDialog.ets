import { media } from "@kit.MediaKit"

@CustomDialog
export struct WordDialog {
  controller: CustomDialogController
  @Prop en: string = ''
  @Prop zh: string = ''
  avPlayer?: media.AVPlayer

  async aboutToAppear() {
    // 创建播放引擎实例
    const avPlayer = await media.createAVPlayer()
    avPlayer.on('stateChange', (state) => {
      // 资源初始化
      if (state == 'initialized') {
        // 播放引擎的资源已准备就绪 - 准备中
        avPlayer.prepare()
      }else if (state == 'prepared') {
        avPlayer.play() // 播放
        avPlayer.loop = true
      }
    })
    avPlayer.url = `https://dict.youdao.com/dictvoice?type=1&audio=${this.en}`
    this.avPlayer = avPlayer
  }

  aboutToDisappear(): void {
    if (this.avPlayer) {
      this.avPlayer.stop()
      this.avPlayer.release()
    }
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text(this.en)
          .fontSize(20)
          .fontColor($r('app.color.white'))
          .fontWeight(500)
        WordSoundComp()
      }

      Text(this.zh)
        .fontColor($r('app.color.white'))
    }
    .constraintSize({ minWidth: 175 })
    .padding({ left: 16, right: 16 })
    .height(90)
    .borderRadius(45)
    .backgroundColor('#8f000000')
    .justifyContent(FlexAlign.Center)
  }
}

@Component
struct WordSoundComp {
  @State flag: boolean = false
  timerId?: number

  aboutToAppear(): void {
    this.timerId = setInterval(() => {
      this.flag = !this.flag
    }, 500)
  }

  aboutToDisappear(): void {
    clearInterval(this.timerId)
  }

  build() {
    Image($r('sys.media.ohos_ic_public_sound'))
      .width(20)
      .aspectRatio(1)
      .fillColor(this.flag ? $r('app.color.common_green') : $r('app.color.white'))
  }
}