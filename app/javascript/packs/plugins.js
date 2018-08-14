import Vue from 'vue/dist/vue.esm'
import Http from './utils/http'
import VueFetch, { $fetch } from './plugins/fetch'
import VueState from './plugins/state'
import state from './state'

Vue.use(Http)
Vue.use(VueFetch, {
    baseUrl: 'http://localhost:3000/',
})
Vue.use(VueState, state)