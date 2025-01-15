import { logger } from './Logger'

// 将其他文件中的成员全部导出
export * from './Logger'
export * from './FullScreen'
export * from './StatusBar'
export * from './Http'
export * from './StudyTime'
export * from './Auth'
export * from './Tracking'
export * from './History'
export * from './ClockIn'
export * from './Permission'

export const calcPercentage= (done:number, total: number) => {
  return Math.round( done / total * 100) + '%'
}