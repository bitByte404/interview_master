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
  3: { text: '简单', color: $r('app.color.common_blue') },
  4: { text: '简单', color: $r('app.color.common_blue') },
  5: { text: '简单', color: $r('app.color.common_main_color') },
}

@Component
export struct HcTag {
  build() {

  }
}