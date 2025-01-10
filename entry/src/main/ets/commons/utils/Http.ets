import axios, { AxiosError, AxiosRequestConfig, AxiosResponse } from '@ohos/axios'
import { logger } from '.'

export  const instance = axios.create({
  baseURL: 'https://api-harmony-teach.itheima.net/hm', // 请求基地址
  timeout: 10000, // 超时时间
})

instance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  logger.info('response --- result', JSON.stringify(response))
  if (response.data.code == 10000) {
    // 请求成功 - 业务处理成功
    return response.data.data
  }
  // 业务处理失败
  return Promise.reject(response.data)
}, (error: AxiosError) => {
  // 对响应错误做点什么
  return Promise.reject(error)
})

// axios痛点
// 1. 请求时，泛型参数有点啰嗦，比如post请求，参数3 不能省略，否则物体时
// 2. 获得接口的数据太麻烦 => 精简 res.data.data => res
class Http {
  // res 返回的数据类型
  // req 请求的数据类型 - get不需要传
  request<res, req = Object>(config: AxiosRequestConfig<req>) {
    return instance<null, res, req>(config)
  }
}

export const http = new Http()