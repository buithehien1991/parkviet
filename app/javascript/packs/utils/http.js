import axios from 'axios'

axios.defaults.withCredentials = true
const http = axios.create({
    baseURL: 'http://localhost:3000/',
})

export function install (Vue) {
  Vue.prototype.$http = http
}

export default http
