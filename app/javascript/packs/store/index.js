import Vue from 'vue'
import Vuex from 'vuex'

import ui from './ui'

Vue.use(Vuex)

export function createStore() {
    const store = new Vuex.Store({
        strict: process.env.NODE_ENV !== 'production',

        actions: {
            init() {

            }
        },

        modules: {
            ui
        }
    })

    if (module.hot) {
        module.hot.accept([
            './ui'
        ], () => {
            store.hotUpdate({
                modules: {
                    ui: require('./ui').default,
                }
            })
        })
    }

}