// 用户类型
export interface User {
  id: string
  username: string
  avatar: string
  token: string
  nickName?: string
  totalTime?: number // 学习时间
  clockinNumbers?: number // 打卡时间
}


// 首页试题分类
export interface QuestionType {
  id: number
  name: string
  // icon: string
  // describeInfo: string
  displayNewestFlag: 0 | 1 // 0表示不展示图标
}

// 首页试题类型
export interface QuestionItem {
  id: string
  stem: string // 题干
  difficulty: number // 难度
  likeCount: number // 点赞数
  views: number // 浏览数
  readFlag: 0 | 1 // 是否已看
}

export interface QuestionDetail extends QuestionItem {
  /* 答案 */
  answer: string
  /* 是否收藏 */
  collectFlag: 0 | 1
  /* 是否点赞 */
  likeFlag: 0 | 1
  /* 所属模块 */
  stage: string[]
}

// 首页试题数据列表结果类型
export interface PageData<T> {
  total: number
  pageTotal: number
  rows: T[]
}

// 首页试题排序规则
export enum SortType {
  Default = 0,
  DifficultyLow = 10,
  DifficultyHigh = 11,
  ViewLow = 20,
  ViewHigh = 21,
  Commend = 30
}

// 首页试题查询数据类型
export interface QuestionListParams {
  type: number
  questionBankType: 9 | 10
  sort?: SortType
  page?: number
  pageSize?: number
  keyword?: string
}

// 点赞或收藏
export interface QuestionOptParams {
  id: string // 试题id
  type: 0 | 1 // 0面试题 1面经
  optType: 1 | 2 // 1点赞 2收藏
}

// 上报数据
export interface TimeItem {
  questionId: string
  startTime: number
  endTime: number
}

// 打卡信息
export interface ClockInItem {
  id: string
  createdAt: string
}

export interface ClockInfo {
  flag: boolean
  clockinNumbers: number
  totalClockinNumber: number
  clockins: ClockInItem[]
}

export interface ClockInfoParams {
  year:  string
  month: string
}

// 学习时间
export interface StudyTimeItem {
  id: string
  name: string
  total: number
  done: number
  undone: number
}

export interface StudyTimeCate {
  type: string
  list: StudyTimeItem[]
}

export interface StudyTimeData {
  totalTime: number
  studyData: StudyTimeCate[]
}