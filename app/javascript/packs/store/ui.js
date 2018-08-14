export default {
    namespaced: true,

    state() {
        return {
            showProductList: true,
        }
    },

    getters: {
        showProductList: state => state.showProductList,
    },

    mutations: {
        showProductList (state, value) {
            state.showProductList = value
        }
    },

    actions: {
        setShowProductList ({ commit }, value) {
            commit('showProductList', value)
        }
    }
}