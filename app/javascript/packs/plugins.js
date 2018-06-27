import Vue from 'vue/dist/vue.esm'
import Http from './utils/http'
import VueFetch, { $fetch } from './plugins/fetch'

Vue.use(Http)
Vue.use(VueFetch, {
    baseUrl: 'http://localhost:3000/',
})