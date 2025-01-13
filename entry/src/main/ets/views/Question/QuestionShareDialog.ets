import { UserInterviewKey } from '../../commons/utils/Auth'
import { QuestionDetail, User } from '../../models'
import { componentSnapshot, promptAction } from '@kit.ArkUI'
import image from '@ohos.multimedia.image'
import { fileIo, fileUri } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'

@CustomDialog
export struct QuestionShareDialog {
  @Prop item: QuestionDetail
  @StorageProp(UserInterviewKey) user: User = {} as User
  controller: CustomDialogController

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column({ space: 20 }) {
        Image($r('app.media.ic_interview_logo'))
          .width(40)
          .height(40)
        Text('面试通，搞定企业面试题')
        Divider()
          .strokeWidth(0.5)
          .color($r('app.color.common_gray_border'))
        Text('大厂面试题：' + this.item.stem)
          .fontSize(12)
          .maxLines(2)
          .fontWeight(600)
          .width('100%')
          .lineHeight(24)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        QRCode(this.item.id)
          .width(160)
          .height(160)
          .alignSelf(ItemAlign.Center)
        Text('扫码查看答案')
          .fontSize(12)
          .alignSelf(ItemAlign.Center)
        Blank()
        Text('分享来自：' + this.user.nickName || this.user.username)
          .fontSize(12)
      }
      .id('share')
      .padding(20)
      .alignItems(HorizontalAlign.Start)
      .width(300)
      .height(500)
      .backgroundColor($r('app.color.white'))


      Row() {
        SaveButton({
          icon: SaveIconStyle.FULL_FILLED,
          text: SaveDescription.SAVE_IMAGE,
          buttonType:  ButtonType.Normal
        })
          .fontColor($r('app.color.white'))
          .fontSize(14)
          .padding(12)
          .backgroundColor($r('app.color.common_main_color'))
          .onClick((event: ClickEvent, result: SaveButtonOnClickResult) => {
            if (result == SaveButtonOnClickResult.SUCCESS) {
              // 用户允许操作
              this.saveImage()
            }
          })
      }
      .borderRadius({ topLeft: 8 })
      .clip(true)
    }
    .borderRadius(8)
    .clip(true)
  }

  async saveImage() {
    // 进行截图
    const pixelMap = await componentSnapshot.get('share')
    //  图片数据
    const imagePacker = image.createImagePacker()
    const arrayBuffer = await imagePacker.packToData(pixelMap, { format: 'image/jpeg', quality: 98 })
    // 存储图片到应用下
    const ctx = getContext(this)
    // 生成图片路径 - 基于时间戳
    const imagePath = ctx.cacheDir + '/' + Date.now() + '.jpeg'
    // 让图片具备创建和读写的能力
    const file = fileIo.openSync(imagePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    // 写入图片数据
    fileIo.writeSync(file.fd, arrayBuffer)
    // 关闭图片
    fileIo.closeSync(file.fd)

    /**
     * 保存到相册: photoAccessHelper写入相册 + 获取保存权限
     * 1. 获取uri
     * 2. 创建相册资源请求 - 图片资产的变更请求
     * 3. 添加创建请求
     */
    // 将图片路径 -> fileUri
    const uri = fileUri.getUriFromPath(imagePath)
    const assetChangeRequest = photoAccessHelper.MediaAssetChangeRequest.createImageAssetRequest(ctx, uri)
    const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(ctx)
    await phAccessHelper.applyChanges(assetChangeRequest)
    promptAction.showToast({
      message: '保存成功'
    })
  }
}