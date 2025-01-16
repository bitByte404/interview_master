import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { JSON } from '@kit.ArkTS'
import { logger } from '../commons/utils'
import { promptAction } from '@kit.ArkUI'

interface ArticleItem extends ValuesBucket {
  id: number
  title: string
  content: string
  create_time: number
}

@Entry
@Component
struct TestPage {
  tableName: string = 'article'
  store?: relationalStore.RdbStore
  @State total: number = 0
  @State list: ArticleItem[] = []

  // 目标：创建数据库实例并初始化表结构
  async aboutToAppear() {
    this.createStore()
  }

  async createStore() {
    const store = await relationalStore.getRdbStore(getContext(this), {
      name: 'my_article.db',
      securityLevel: relationalStore.SecurityLevel.S1 // 安全级别
    })
    // 初始化表结构
    store.executeSql(`
      CREATE TABLE IF NOT EXISTS ${this.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        create_time INTEGER NOT NULL
        )
    `)
    this.store = store
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Button('添加')
          .onClick(async () => {
            try {
              // 插入数据之后的返回结果
              // rowId == undefined or -1 证明插入失败了
              const rowId = await this.store?.insert(this.tableName, {
                id: null,
                title: '我是标题' + Math.random(),
                content: '我是内容' + Math.random(),
                create_time: Date.now()
              })
              promptAction.showToast({ message: '添加成功' + rowId })
            } catch (error) {
              promptAction.showToast({
                message: '添加失败'
              })
            }
          })

        Button('查询总条数')
          .onClick(async () => {
            // 1. 查询条件对象
            const predicates = new relationalStore.RdbPredicates(this.tableName)
            // 2. 根据查询条件对象去从查询条数
            if (this.store) {
              const resultSet = await this.store.query(predicates)
              // 3. 拿到总条数
              this.total = resultSet.rowCount
              resultSet.close()
            }
          })
        Text('总条数：' + this.total)
        Button('查询所有数据')
          .onClick(async () => {
            const predicates = new relationalStore.RdbPredicates(this.tableName)
            // 2. 根据查询条件对象去从查询条数
            if (this.store) {
              const resultSet = await this.store.query(predicates)
              // 3. 判断是否有下一行
              // 4. 获取字段id title对应列的行
              // 5. 根据索引再获取对应的数据
              // 依次类推，直到没有下一行数据，证明数据获取完毕
              const list: ArticleItem[] = []
              while (resultSet.goToNextRow()) {
                const idIndex = resultSet.getColumnIndex('id')
                const titleIndex = resultSet.getColumnIndex('title')
                list.push({
                  id: resultSet.getLong(resultSet.getColumnIndex('id')),
                  title: resultSet.getString(resultSet.getColumnIndex('title')),
                  content: resultSet.getString(resultSet.getColumnIndex('content')),
                  create_time: resultSet.getLong(resultSet.getColumnIndex('create_time')),
                })
                logger.info('---id的数据为：' + resultSet.getLong(idIndex))
                logger.info('---title的数据为：' + resultSet.getString(titleIndex))
              }
              this.list = list
              resultSet.close()
            }
          })
        Text('所有数据：' + JSON.stringify(this.list))
        Button('修改')
          .onClick(() => {
            const item = this.list[0]
            item.title = '修改了标题' + Math.random()
            // 1. 查询条件对象
            const predicates = new relationalStore.RdbPredicates(this.tableName)
            // 2. 删除数组中第一条数据
            if (this.store) {
              // 2.1 匹配到该条数据
              predicates.equalTo('id', item.id)
              // 2.2 再进行修改
              this.store.updateSync(item, predicates)
            }
          })
        Button('删除')
          .onClick(() => {
            const item = this.list[0]
            // 1. 查询条件对象
            const predicates = new relationalStore.RdbPredicates(this.tableName)
            // 2. 删除数组中第一条数据
            if (this.store) {
              // 2.1 匹配到该条数据
              predicates.equalTo('id', item.id)
              // 2.2 再进行删除
              this.store.deleteSync(predicates)
            }
          })
        Button('删除数据库')
          .onClick(() => {
            relationalStore.deleteRdbStore(getContext(this), 'my_article.db')
          })
      }
      .width('100%')
      .padding({ top: 60 })
    }
    .height('100%')
    .width('100%')
  }
}