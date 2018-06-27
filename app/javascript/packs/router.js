import Vue from 'vue'
import VueRouter from 'vue-router'

import Sale from './components/Sale'

Vue.use(VueRouter)

const routes = [
    { path: '/', name: 'sale', components: Sale }
]

const router = new VueRouter({
    routes,
    mode: 'history',
    scrollBehavior (to, from, savedPosition) {
        if (savedPosition) {
            return savedPosition
        }
        if (to.hash) {
            return { selector: to.hash }
        }
        return { x: 0, y: 0 }
    },
})
export default router