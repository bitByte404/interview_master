interface HcTagInfo {
  color: ResourceColor
  text: string
}

// 1. interface
/*interface HcData {
  '1' : HcTagInfo
  '2': HcTagInfo
  '3': HcTagInfo
  '4': HcTagInfo
  '5': HcTagInfo
}

const data: HcData = {
  '1': { text: '简单', color: $r('app.color.common_green') },
  '2': { text: '简单', color: $r('app.color.common_green') },
  '3': { text: '简单', color: $r('app.color.common_blue') },
  '4': { text: '简单', color: $r('app.color.common_blue') },
  '5': { text: '简单', color: $r('app.color.common_main_color') },
}*/

// 2. Record
// 工具类型 -> 生成一个对象类型 接受泛型参数
// 参数1：对象的键
// 参数2：对象的值

const data: Record<number, HcTagInfo> = {
  1: { text: '简单', color: $r('app.color.common_green') },
  2: { text: '简单', color: $r('app.color.common_green') },
  3: { text: '一般', color: $r('app.color.common_blue') },
  4: { text: '一般', color: $r('app.color.common_blue') },
  5: { text: '困难', color: $r('app.color.common_main_color') },
}

@Component
@Preview
export struct HcTag {
  @Prop difficulty: number = 1
  @Prop text: string = ''
  @Prop color: ResourceColor = ''

  build() {
    Text(this.text || data[this.difficulty].text)
      .fontSize(13)
      .fontColor(this.color || data[this.difficulty].color)
      .padding({ left: 6, right: 6 , top: 2, bottom: 2})
      .height(18)
      .constraintSize({
        minWidth: 34
      })
      .borderRadius(2)
      .backgroundColor($r('app.color.common_gray_bg'))
  }
}