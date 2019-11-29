/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import 'babel-polyfill'
import Vue from 'vue/dist/vue.esm'
import router from './router'
import * as filters from './filters'
import './components'
import store from './store/index'

import App from '../app.vue'

// Global filters
for (const key in filters) {
  Vue.filter(key, filters[key])
}

// Import Vue Modal
// import VModal from 'vue-js-modal'
// Vue.use(VModal, { dialog: true })

import BootstrapVue from 'bootstrap-vue'
Vue.use(BootstrapVue)
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

document.addEventListener('DOMContentLoaded', () => {
    function main() {
        new Vue({
            router,
            store,
            render: h => h(App)
        }).$mount('#sale-page')
    }
    main()
})