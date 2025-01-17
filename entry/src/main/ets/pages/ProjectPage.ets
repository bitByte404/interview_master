import { logger, req } from "../commons/utils"
import { ProjectType, StudyTimeData, StudyTimeItem } from "../models"
import { ProjectsItemComp } from "../views/Projects/ProjectsItemComp"
import { JSON } from "@kit.ArkTS"
import { emitter } from "@kit.BasicServicesKit"
import { LOGIN_EVENT } from "../commons/constants"
import { HcSkeleton, HcSkeletonItem } from "../commons/components"


@Component
@Preview
export struct ProjectPage {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State list: ProjectType[] = []
  @State studyInfos: StudyTimeItem[] = []
  @State isLoading: boolean = false

  aboutToAppear() {
    this.updateData()
    emitter.on(LOGIN_EVENT, (event: emitter.EventData) => {
      this.updateData()
    })
  }

  async updateData() {
    this.isLoading = true
    await this.updateProjects()
    await this.updateStudyData()
    this.isLoading = false
  }

  async updateProjects() {
    this.list = await req.request<ProjectType[]>({
      url: 'question/type',
      params: {
        type: 'items'
      }
    })
  }

  async updateStudyData() {
    const res = await req.request<StudyTimeData>({
      url: '/studyInfo',
    })
    this.studyInfos = res.studyData[1].list
    logger.warn('studyInfos', JSON.stringify(this.studyInfos))
  }

  @Builder
  SkeletonBuilder() {
    Column() {
      HcSkeleton() {
        Column({ space: 11 }) {
          ForEach(new Array(6).fill(0), () => {
            Row({ space: 6 }) {
              HcSkeletonItem({ widthValue: '20%', heightValue: '80' })
              Column({ space: 6 }) {
                HcSkeletonItem({ widthValue: '70%' })
                HcSkeletonItem({ widthValue: '75%' })
                HcSkeletonItem({ widthValue: '70%' })
              }
              .layoutWeight(1)
              .height(90)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Center)
            }
            .backgroundColor($r('app.color.white'))
            .borderRadius(9.5)
            .padding(6)
          })
        }
        .width('100%')
      }
    }
  }

  build() {
    Column() {
      Text('项目')
        .fontWeight(400)
        .fontSize(24)
        .lineHeight(40)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({left: 14})
        .margin({
          bottom: 8,
          left: 16,
          right: 16
        })


      if (this.isLoading) {
        Column() {
          this.SkeletonBuilder()
        }
        .margin({
          left: 11,
          right: 11
        })
        .layoutWeight(1)
      } else {
        List({ space: 11 }) {
          ForEach(this.list, (item: ProjectType, index) => {
            ListItem() {
              ProjectsItemComp({ item, studyTime: this.studyInfos[index] })
            }
          })
        }
        .margin({
          left: 11,
          right: 11
        })
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_gray_bg'))
    .padding({
      top: this.topHeight,
    })
  }
}