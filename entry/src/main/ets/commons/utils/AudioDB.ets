import { Context } from "@kit.AbilityKit"
import { relationalStore, ValuesBucket } from "@kit.ArkData"
import { when } from "@ohos/hamock"

export interface InterviewAudioItem extends ValuesBucket {
  id: number
  user_id: string
  name: string
  path: string
  duration: number
  size: number
}

class AudioDB {
  tableName: string = 'interview_audio'
  store?: relationalStore.RdbStore

  // 初始化数据
  async initStore() {
    const ctx = AppStorage.get<Context>('context')
    if (ctx) {
      const store = await relationalStore.getRdbStore(ctx, {
        name: 'interview_audio.db',
        securityLevel: relationalStore.SecurityLevel.S1
      })
      const sql = `
      CREATE TABLE IF NOT EXISTS ${this.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        path TEXT NOT NULL,
        duration INTEGER NOT NULL,
        size INTEGER NOT NULL
      )`
      await store.executeSql(sql)
      this.store = store
    }
  }

  // 插入数据
  insert(item: InterviewAudioItem) {
    const rowId = this.store?.insertSync(this.tableName, item)
    if (rowId == undefined || rowId < 1) {
      return Promise.reject('insert fail')
    }
    return Promise.resolve()
  }

  // 删除数据
  delete(id: number) {
    // 创建一个查询对象
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    // 根据id匹配删除的项
    predicates.equalTo('id', id)
    const rowCount = this.store?.deleteSync(predicates)
    if (rowCount == undefined || rowCount <= 0) {
      return Promise.reject('delete fail')
    }
    return Promise.resolve()
  }

  // 修改数据
  update(item: InterviewAudioItem) {
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    // 根据id匹配
    predicates.equalTo('id', item.id)
    const rowCount = this.store?.updateSync(item, predicates)
    if (rowCount == undefined || rowCount <= 1) {
      return Promise.reject('update fail')
    }
    return Promise.reject()
  }

  // 查询数据 基于用户的id
  query(userId: string): Promise<InterviewAudioItem[]> {
    const predicates = new relationalStore.RdbPredicates(this.tableName)
    // 根据id匹配
    predicates.equalTo('user_id', userId)
    const resultSet = this.store?.querySync(predicates)
    if (!resultSet) return Promise.reject('query fail')
    const list: InterviewAudioItem[] = []
    while (resultSet?.goToNextRow()) {
      list.push({
        id: resultSet.getLong(resultSet.getColumnIndex('id')),
        user_id: resultSet.getString(resultSet.getColumnIndex('user_id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        path: resultSet.getString(resultSet.getColumnIndex('path')),
        duration: resultSet.getLong(resultSet.getColumnIndex('duration')),
        size: resultSet.getLong(resultSet.getColumnIndex('size')),
      })
    }
    // 关闭数据库防止内存泄露
    resultSet.close()
    return Promise.resolve(list)
  }
}

export const audioDB = new AudioDB()