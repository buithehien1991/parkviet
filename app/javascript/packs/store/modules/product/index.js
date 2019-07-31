import axios from 'axios'
import config from '../../../config'

const state = {
    products: [],
    showProductList: true
}

const mutations = {
    UPDATE_PRODUCT_ITEMS (state, payload) {
        state.products = payload
    },
    UPDATE_SHOW_PRODUCT_LIST(state, payload) {
        state.showProductList = payload
    }
}

const actions = {
    getProductItems({ commit }) {
        axios.get(config.PRODUCTS_PATH).then((response) =>  {
            commit('UPDATE_PRODUCT_ITEMS', response.data)
        })
    },
    updateShowProductList({ commit }, showProductList) {
        commit('UPDATE_SHOW_PRODUCT_LIST', showProductList)
    }
}

const getters = {
    products: state => state.products,
    showProductList: state => state.showProductList
}

const productModule = {
    state, mutations, actions, getters
}

export default productModule