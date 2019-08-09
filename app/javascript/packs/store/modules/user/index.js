import axios from 'axios'
import config from '../../../config'

const state = {
    user: {},
    customers: [],
    currentCustomer: null
}

const mutations = {
    UPDATE_USER_INFO(state, payload) {
        state.user = payload
    },

    UPDATE_CUSTOMERS(state, payload) {
        state.customers = payload
    }
}

const actions = {
    getUserInfo({ commit }) {
        axios.get(config.USER_INFO_PATH).then((response) => {
            commit('UPDATE_USER_INFO', response.data)
        })
    },
    getCustomers({ commit }) {
        axios.get(config.CUSTOMERS_PATH).then((response) => {
            commit('UPDATE_CUSTOMERS', response.data)
        })
    }
}

const getters = {
    user: state => state.user
}

const userModule = {
    state, mutations, actions, getters
}

export default userModule