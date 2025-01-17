import { auth, req, UserInterviewKey } from '../commons/utils'
import { User } from '../models'
import { HcLoadingDialog, HcNavBar } from '../commons/components'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { fileIo } from '@kit.CoreFileKit'
import { FormData } from '@ohos/axios'
import image from '@ohos.multimedia.image'

interface UserInfoData {
  avatar: string
  nickName: string
}

@Entry
@Component
struct ProfilePage {
  @StorageProp(UserInterviewKey) user: User = {} as User
  dialog: CustomDialogController = new CustomDialogController({
    builder: HcLoadingDialog({ message: '更新中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async updateAvatar() {
    // 1. 打开相册选择一张图片
    // 1.1 定义选择图片的参数
    const options = new photoAccessHelper.PhotoSelectOptions()
    // 1.2 指定文件类型是图片
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    // 1.3 只选择一张图
    options.maxSelectNumber = 1
    // 1.4 创建相册选择器
    const picker = new photoAccessHelper.PhotoViewPicker()
    // 1.5 选择图片
    const selectResult = await picker.select(options)
    // 1.6 得到图片完整uri路径
    const uri = selectResult.photoUris[0]
    this.dialog.open()

    // 2. 压缩图片后再上传
    const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY)
    const imageSource = image.createImageSource(file.fd)
    const imagePacker = image.createImagePacker()
    const arrayBuffer = await imagePacker.packToData(imageSource, {
      format: 'image/jpeg',
      quality: 70
    })
    const newFilePath = getContext(this).cacheDir + '/' + Date.now() + '.jpg'
    const newFile = fileIo.openSync(newFilePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    fileIo.writeSync(newFile.fd, arrayBuffer)
    fileIo.closeSync(newFile.fd)
    // 创建fromData对象 - 装载图片
    const fromData = new FormData()
    fromData.append('file', `internal://cache/${newFile.name}`)
    await req.request<string>({
      method: 'post',
      url: '/userInfo/avatar',
      data: fromData,
      headers: { 'Content-Type': 'multipart/form-data' },
      context: getContext(this)
    })
    // 获取用户信息
    const user = await req.request<User>({
      url: '/userInfo'
    })
    this.dialog.close()
    this.user.avatar = user.avatar
    auth.setUser(this.user)
  }

  build() {
    Column() {
      HcNavBar({ title: '编辑资料', showRightIcon: false })
      List() {
        ListItem() {
          Row() {
            Text('头像')
            Image(this.user.avatar || $r('app.media.ic_mine_avatar'))
              .alt($r('app.media.ic_mine_avatar'))
              .width(40)
              .aspectRatio(1)
              .borderRadius(20)
              .border({ width: 0.5, color: $r('app.color.common_gray_border') })
              .onClick(() => {
                this.updateAvatar()
              })
          }
          .width('100%')
          .height(60)
          .justifyContent(FlexAlign.SpaceBetween)
        }

        ListItem() {
          Row() {
            Text('昵称')
            TextInput({ text: this.user.nickName })
              .fontColor($r('app.color.common_gray_03'))
              .textAlign(TextAlign.End)
              .layoutWeight(1)
              .padding(0)
              .height(60)
              .backgroundColor($r('app.color.white'))
              .borderRadius(0)
              .onChange((value) => this.user.nickName = value)
              .onSubmit(async () => {
                if (this.user.nickName?.trim()) {
                  this.dialog.open()
                  await req.request<null, UserInfoData>({
                    method: 'post',
                    url: '/userInfo/profile',
                    data: {
                      avatar: this.user.avatar,
                      nickName: this.user.nickName!
                    }
                  })
                  const user = await req.request<User>({
                    url: '/userInfo'
                  })
                  this.user.username = user.username
                  auth.setUser(this.user)
                  this.dialog.close()
                }
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }
      .width('100%')
      .height('100%')
      .padding({
        left: 35,
        right: 35,
        top: 15,
        bottom: 15
      })
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_bg') })
    }
  }
}