import { HcNavBar } from '../../commons/components/HcNavBar'
import { audioDB, auth, InterviewAudioItem } from '../../commons/utils'
import { AudioItemComp } from './AudioItemComp'
import { AudioRecordComp } from './AudioRecordComp'
import { promptAction } from '@kit.ArkUI'
import { AudioPlayer } from './AudioPlayer'

@Component
export struct AudioView {
  @State list: InterviewAudioItem[] = []
  @State currentItem: InterviewAudioItem = {} as InterviewAudioItem
  @State isShow: boolean = false
  dialog = new CustomDialogController({
    builder: InputDialog({
      name: this.currentItem.name,
      onSubmit: async (name) => {
        const item = this.currentItem
        item.name = name
        await audioDB.update(item)
        this.getList()
        this.dialog.close()
      }
    }), customStyle: true,
  })

  @Builder
  PlayerBuilder() {
    Column() {
      AudioPlayer({
        item: this.currentItem
      })
    }
  }

  async aboutToAppear() {
    // 初始化数据库和表结构
    await audioDB.initStore()
    // 基于当前用户查询数据渲染列表
    this.getList()
  }

  async getList() {
    const user = auth.getUser()
    this.list = await audioDB.query(user.id)
  }

  @Builder
  ListItemSwiperBuilder(item: InterviewAudioItem) {
    Row() {
      Text('编辑')
        .actionButton($r('app.color.common_blue'))
        .onClick(() => {
          this.currentItem = item
          this.dialog.open()
        })
      Text('删除')
        .actionButton('#FF0033')
        .onClick(() => {
          audioDB.delete(item.id!)
          promptAction.showToast({ message: '删除成功' })
          this.getList()
        })
    }
    .height('100%')
  }

  build() {
    Column() {
      HcNavBar({ title: '面试录音', showRightIcon: false })
      Column() {
        List() {
          ForEach(this.list, (item: InterviewAudioItem) => {
            ListItem() {
              AudioItemComp({ item })
                .onClick(() => {
                  this.currentItem = item
                  this.isShow = true
                })
            }
            .swipeAction({
              end: this.ListItemSwiperBuilder(item)
            })
          })
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .layoutWeight(1)

      AudioRecordComp({
        onRecordEnd: async (item: InterviewAudioItem) => {
          // 向数据库插入一条数据
          await audioDB.insert(item)
          // 重新渲染
          this.getList()
        }
      })
    }
    .bindContentCover($$this.isShow, this.PlayerBuilder())
    .width('100%')
    .height('100%')
  }
}

@Extend(Text)
function actionButton(color: ResourceColor) {
  .width(80)
  .aspectRatio(1)
  .backgroundColor(color)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.white'))
}


@CustomDialog
struct InputDialog {
  controller: CustomDialogController
  @Prop name: string = ''
  onSubmit: (name: string) => void = () => {
  }

  @Builder
  PlayerBuilder() {
    Column() {
    }
  }

  build() {
    Column({ space: 12 }) {
      Text('修改名字：')
        .height(40)
        .fontWeight(500)
      TextInput({ text: $$this.name })
      Row({ space: 120 }) {
        Text('取消')
          .fontWeight(500)
          .fontColor($r('app.color.common_gray_02'))
          .onClick(() => {
            this.controller.close()
          })
        Text('确认')
          .fontWeight(500)
          .fontColor($r('app.color.common_blue'))
          .onClick(() => {
            this.onSubmit(this.name)
          })
      }
      .height(40)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(16)
    .borderRadius(12)
    .width('80%')
    .backgroundColor($r('app.color.white'))
  }
}