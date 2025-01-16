import { common, Permissions, Want } from '@kit.AbilityKit';
import { logger, permission } from '../commons/utils';
import { promptAction, router } from '@kit.ArkUI';
import { media } from '@kit.MediaKit';
import fileIo from '@ohos.file.fs';
import { AudioBoComp } from '../views/Audio/AudioBoComp';


@Entry
@Component
struct AudioPage {
  @State message: string = 'Hello World';
  permissions: Permissions[] = ['ohos.permission.MICROPHONE']
  filePath?: string // 录音文件位置
  fd?: number
  avRecorder?: media.AVRecorder
  @State maxAmplitude: number = 0
  @State timer: number = 0
  avPlayer?: media.AVPlayer
  @State value: number = 0 // 当前时长
  @State total: number = 0 // 总时长

  /**
   * 目标：麦克风授权 - 授权提示框 + 开启权限设置面板
   * 授权提示框：
   * 1. module.json5配置权限 - 针对于用户敏感权限
   *    name + reason + usedScene 权限名称 + 授权理由 + 使用场景
   *
   * 2. abilityAccessControl.createAtManager 索要权限
   * 3. 创建权限管理对象
   * 4. 弹窗授权窗口
   * 5. 判断是否授权
   */

  aboutToAppear(): void {
    this.getPermission()
  }

  async getPermission() {
    try {
      // 第一次授权
      const isAuth = await permission.requestPermissions(this.permissions)
      if (!isAuth) {
        const confirm = await promptAction.showDialog({
          title: '温馨提示',
          message: '未授权使用麦克风将无法使用该面试录音功能，是否前往设置进行授权？',
          buttons: [{ text: '离开', color: $r('app.color.common_gray_01') },
            { text: '去授权', color: $r('app.color.black') }]
        })
        if (confirm.index == 1) {
          // 二次授权
          const isAgainAuth = await permission.requestPermissionSetting(this.permissions)
          if (isAgainAuth) {
            return
          }
        }
        router.back()
      }
    } catch (err) {
      // 点击弹窗外关闭弹窗会返回错误的promise
      router.back()
    }
  }

  async startRecord() {
    // 1. 准备一个文件接受录音的数据
    const ctx = getContext(this)
    const filePath = ctx.filesDir + '/' + Date.now() + '.m4a'
    this.filePath = filePath
    // 为录音文件设置路径并开启创建读写的能力
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE)
    this.fd = file.fd // 获取录制文件fd
    // 2. 准备录音配置对象信息
    const avConfig: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      profile: {
        audioBitrate: 100000, // 音频比特率
        audioChannels: 1, // 音频声道数
        audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前只支持aac
        audioSampleRate: 48000, // 音频采样率
        fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前只支持m4a
      },
      url: `fd://${file.fd}`
    }
    // 3. 使用avRecorder实现录音功能
    const avRecorder = await media.createAVRecorder()
    await avRecorder.prepare(avConfig)
    await avRecorder.start() // 开始录音
    this.avRecorder = avRecorder

    // 4. 获取振幅数据
    this.timer = setInterval(async () => {
      this.maxAmplitude = await avRecorder.getAudioCapturerMaxAmplitude()
      logger.info('振幅的数据', this.maxAmplitude.toString())
    }, 100)
    promptAction.showToast({
      message: '开始'
    })
  }

  // 结束录音
  async stopRecord() {
    try {
      promptAction.showToast({
        message: '停止'
      })
      if (this.avRecorder) {
        // 先停止
        await this.avRecorder.stop()
        // 再清除
        await this.avRecorder.release()
        // 最后关闭文件
        fileIo.closeSync(this.fd)
        clearInterval(this.timer)
      }
    } catch (error) {
      logger.error('停止录音出错', JSON.stringify(error))
    }
  }

  // 开始播放
  async startPlay() {
    const file = fileIo.openSync(this.filePath, fileIo.OpenMode.READ_ONLY)
    const avPlayer = await media.createAVPlayer()
    avPlayer.on('stateChange', state => {
      if (state == 'initialized') {
        avPlayer.prepare()
      } else  if (state == 'prepared') {
        avPlayer.loop = true
        avPlayer.play()
        // 获取音频时长
        this.total = avPlayer.duration
      }
    })
    // 监听播放时间改变
    avPlayer.on('timeUpdate', (time) => {
      this.value = time
    })
    avPlayer.url = `fd://${file.fd}`
    promptAction.showToast({message: 'fd:' + file.fd})
    this.avPlayer = avPlayer
  }

  // 结束录音
  async stopPlay() {
    if (this.avPlayer) {
      await this.avPlayer.stop()
      this.avPlayer.release()
    }
  }

  build() {
    Column({ space: 50 }) {
      Button('打开设置页')
        .onClick(() => {
          let want: Want = {
            bundleName: 'com.huawei.hmos.settings',
            abilityName: 'com.huawei.hmos.settings.MainAbility',
            uri: 'application_info_entry',
            parameters: {
              pushParams: 'com.example.interview_master'
            }
          }
          const context = getContext(this) as common.UIAbilityContext
          context.startAbility(want)
        })

      Button('开始录音')
        .onClick(() => {
          this.startRecord()
        })
      Button('结束录音')
        .onClick(() => {
          this.stopRecord()
        })
      Button('开始播放')
        .onClick(() => {
          this.startPlay()
        })
      Button('结束播放')
        .onClick(() => {
          this.stopPlay()
        })
      AudioBoComp({ maxAmplitude: this.maxAmplitude })

      Progress({value: this.value, total: this.total})
        .width('100%')
    }
    .padding(50)
    .height('100%')
    .width('100%')
  }
}