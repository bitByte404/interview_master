import { router } from '@kit.ArkUI';
import { QuestionPageParams } from '../commons/component';

@Entry
@Component
struct QuestionPage {
  @State message: string = '试题详情';

  aboutToAppear(): void {
    // 获取上一个页面传来的参数
    const params = router.getParams() as QuestionPageParams
    this.message = params.item.stem
  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('QuestionPageHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}