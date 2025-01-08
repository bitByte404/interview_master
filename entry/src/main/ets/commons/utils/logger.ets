import { hilog } from '@kit.PerformanceAnalysisKit'

// 定义输出标识
const Tag = 'MyLogger'


class Logger {
  private domain: number // 十六进制格式的输出业务格式
  private tag: string // 指定的标识(自己标识)
  private format: string = '%{public}s, %{public}s' // 格式化的方式

  constructor(domain: number, tag: string) {
    this.domain = domain
    this.tag = tag
  }

  // 优化输出的字符显示状态
  formatArg(arg: string[]) {
    this.format = arg.length > 1 ? '%{public}s, %{public}s' : '%{public}s'
  }

  debug(...args: string[]): void {
    this.formatArg(args)
    hilog.debug(this.domain, this.tag, this.format, args)
  }

  info(...args: string[]): void {
    this.formatArg(args)
    hilog.info(this.domain, this.tag, this.format, args)
  }

  warn(...args: string[]): void {
    this.formatArg(args)
    hilog.warn(this.domain, this.tag, this.format, args)
  }

  error(...args: string[]): void {
    this.formatArg(args)
    hilog.error(this.domain, this.tag, this.format, args)
  }
}

export const logger = new Logger(0x1234, Tag)