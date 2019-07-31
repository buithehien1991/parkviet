import axios from 'axios'
import config from '../../../config'

const state = {
    orders: []
}

const mutations = {
    UPDATE_ORDER_ITEMS(state, payload) {
        state.orders = payload
    },

    ADD_ORDER_ITEMS(state, orderItem) {
        state.orders.push(orderItem)
    }
}

const actions = {
    getOrderItems({ commit }) {
        // axios.get(config.ORDERS_PATH).then((response) => {
        //     commit('UPDATE_ORDER_ITEMS', response.data)
        // })
        commit('UPDATE_ORDER_ITEMS', [])
    },

    /**
     * Tạo 1 hóa đơn mới và lưu lên server
     * @param commit
     * @param orderItem
     */
    addOrderItem({ commit }, orderItem) {
        commit('ADD_ORDER_ITEMS', orderItem)
    },

    /**
     * Xóa 1 hóa đơn đã tạo
     * @param commit
     * @param orderItem
     */
    removeOrderItem({ commit }, orderItem) {

    },

    /**
     * Thêm 1 hàng hóa vào 1 hóa đơn
     * @param commit
     * @param orderItem
     * @param item
     */
    addItemToOrder({ commit }, orderItem, item) {

    },

    /**
     * Xóa 1 hàng hóa khỏi 1 hóa đơn
     * @param commit
     * @param orderItem
     * @param item
     */
    removeItemInOrder({ commit }, orderItem, item) {

    },

    /**
     * Xóa tất cả hàng xóa trong 1 hóa đơn. Nhưng không xóa hóa đơn.
     * @param commit
     * @param orderItem
     */
    removeAllIteminOrder({ commit }, orderItem) {

    }
}

const getters = {
    orders: state => state.orders,
    totalPriceByOrderId: (state) => (orderId) => {
        // TODO tính tổng tiền cho 1 hóa đơn
    },
    quantityByOrderId: (state) => (orderId) => {
        // TODO tính tổng số hàng hóa cho 1 hóa đơn
    }

}

const orderModule = {
    state, mutations, actions, getters
}

export default orderModule