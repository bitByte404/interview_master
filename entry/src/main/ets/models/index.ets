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

export interface ProjectType extends QuestionType {
  icon: string
  describeInfo: string
  tag: ProjectTags[]
}

export interface ProjectTags {
  tagName: string
  nameColor: string
  borderColor: string
}

// 面经类型
export interface InterviewItem {
  id: string
  questionNo?: string
  stem: string
  content: string
  likeCount: number // 点赞数
  views: number // 浏览数
}

export interface InterviewData {
  total: number
  pageTotal: number
  rows: InterviewItem[]
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

export interface InterviewDetail {
  /**
   * 0未收藏1收藏
   */
  collectFlag: number;
  /**
   * 面经的内容，为面经时才有自豪
   */
  content: null | string;
  /**
   * 创建时间
   */
  createdAt: string;
  /**
   * 创建者头像-面经
   */
  creatorAvatar: string;
  /**
   * 创建者名称-面经
   */
  creatorName: string;
  /**
   * 主键id-试题id
   */
  id: string;
  /**
   * 点赞数-面经
   */
  likeCount: number;
  /**
   * 是否点赞0未点赞1已点赞
   */
  likeFlag: number;
  /**
   * 关联问题：面经才有关联问题
   */
  relatedQuestions?: RelatedQuestion[];
  /**
   * 阶段待定-知识点
   */
  stage?: string[];
  /**
   * 题目的题干/面经的标题
   */
  stem: string;
  /**
   * 浏览量
   */
  views: number;
}

export interface RelatedQuestion {
  /**
   * 入库时间
   */
  createdAt?: string;
  /**
   * 题目id
   */
  id: string;
  /**
   * 题号/面经的标题
   */
  questionNo?: string;
  /**
   * 题干
   */
  stem: string;
}