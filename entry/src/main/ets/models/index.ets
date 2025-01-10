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
  sort? : SortType
  page?: number
  pageSize?: number
}