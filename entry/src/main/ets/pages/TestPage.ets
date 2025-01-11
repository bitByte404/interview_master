import { HcSkeleton, HcSkeletonItem } from '../commons/component'

@Entry
@Component
struct TestPage {
  build() {
    Column() {
      HcSkeleton() {
        Column({space: 20}) {
          HcSkeletonItem({widthValue: '80%'})
          HcSkeletonItem({widthValue: 200})
          HcSkeletonItem()
          Row({space: 10}) {
            HcSkeletonItem({widthValue: '20%'})
            HcSkeletonItem({widthValue: '20%'})
            HcSkeletonItem({widthValue: '20%'})
            HcSkeletonItem({widthValue: '20%'})
            HcSkeletonItem({widthValue: '20%'})
          }.width('100%')
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: 5
        })
      }
    }
  }
}