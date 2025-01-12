import { HcNavBar } from '../commons/components/HcNavBar'
import { webview } from '@kit.ArkWeb'
import { router } from '@kit.ArkUI'

interface WebPageParams {
  title: string
  src: string
}

@Entry
@Component
struct WebPage {
  @State title: string = ''
  @State src: string = ''
  controller = new webview.WebviewController()

  aboutToAppear(): void {
    const params = router.getParams() as WebPageParams
    this.title = params.title
    this.src = params.src
  }

  build() {
    Column() {
      HcNavBar({ title: this.title, showRightIcon: false })
      Web({ src: this.src, controller: this.controller })
        .layoutWeight(1)
        .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}