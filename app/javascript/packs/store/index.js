import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

import product from './modules/product'
import user from './modules/user'
import order from './modules/order'
import axios from 'axios'

Vue.use(Vuex)
axios.defaults.withCredentials = true

export default new Vuex.Store({
    modules: {
        product, user, order
    }
})