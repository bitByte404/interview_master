import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { auth, logger } from '.'
import { User } from '../../models'
import { promptAction, router } from '@kit.ArkUI'

export  const instance = axios.create({
  baseURL: 'https://api-harmony-teach.itheima.net/hm', // 请求基地址
  timeout: 10000, // 超时时间
})

/**
 * 拦截器
 * 请求拦截器
 * 1. 统一携带通用的数据，比如token - 身份认证机制
 *
 * 响应拦截器
 * 1. 数据剥离（方便数据的获取） response -> response.data.data
 * 2. 统一处理错误/异常 - token失效或没传
 */

// 添加请求拦截器
// 作用：统一携带参数，比如身份认证标识token
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  logger.info('请求拦截器', JSON.stringify(config))
  const user = auth.getUser()
  if (user.token) {
    config.headers.Authorization = `Bearer ${user.token}`
  }
  return config
}, (error: AxiosError) => {
  // 对请求错误做点什么
  return Promise.reject(error)
})

instance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  logger.info('response --- result', JSON.stringify(response))
  if (response.data.code == 10000) {
    // 请求成功 - 业务处理成功
    return response.data.data
  }
  // 业务处理失败 （请求成功，但是业务功能失败）
  return Promise.reject(response.data)
}, (error: AxiosError) => {
  // 对响应错误做点什么
  logger.error('res ------失败', JSON.stringify(error))
  // 统一处理错误
  if (error.response?.status == 401) {
    // token 没传/失效
    // 1.请求用户信息
    auth.setUser({} as User)
    // 2.去登陆页面
    router.pushUrl({
      url: 'pages/LoginPage',
    }, router.RouterMode.Single) // 单实例模式，防止多次请求时创建多个登录页
    // 3.提示用户
    promptAction.showToast({
      message: '登录过期，请重新登录'
    })
  }
  return Promise.reject(error)
})

// axios痛点
// 1. 请求时，泛型参数有点啰嗦，比如post请求，参数3 不能省略，否则无提示
// 2. 获得接口的数据太麻烦 => 精简 res.data.data => res
class Http {
  // res 返回的数据类型
  // req 请求的数据类型 - get不需要传
  request<res, req = Object>(config: AxiosRequestConfig<req>) {
    return instance<null, res, req>(config)
  }
}

export const req = new Http()