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
