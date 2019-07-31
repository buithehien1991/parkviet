import axios from 'axios'
import config from '../../../config'

const state = {
    products: []
}

const mutations = {
    UPDATE_PRODUCT_ITEMS (state, payload) {
        state.products = payload
    }
}

const actions = {
    getProductItems({ commit }) {
        axios.get(config.PRODUCTS_PATH).then((response) =>  {
            commit('UPDATE_PRODUCT_ITEMS', response.data)
        })
    }
}

const getters = {
    products: state => state.products
}

const productModule = {
    state, mutations, actions, getters
}

export default productModule