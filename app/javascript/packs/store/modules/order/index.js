import axios from 'axios'
import config from '../../../config'

const state = {
    orders: [],
    selectedOrderId: null
}

const mutations = {
    UPDATE_ORDER_ITEMS(state, payload) {
        state.orders = payload
    },

    ADD_ORDER_ITEMS(state, orderItem) {
        state.orders.push(orderItem)
    },

    REMOVE_ORDER_ITEMS(state, orderItem) {
        const index = state.orders.findIndex(order => order.id === orderItem.id)
        state.orders.splice(index, 1)
    },

    ADD_ITEM_TO_ORDER(state, item) {
        var currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            let currentOrderProducts = currentOrder.orderProducts

            let orderProductExists = false;
            currentOrderProducts.map((orderProduct) => {
                if (orderProduct.id === item.id) {
                    orderProduct.quantity++;
                    orderProductExists = true;
                }
            })

            if (!orderProductExists) {
                item.quantity = 1
                currentOrderProducts.push(item)
            }

            currentOrder.orderProducts = currentOrderProducts

            state.orders = state.orders.map((order) => {
                if (order.id === state.selectedOrderId) {
                    order = currentOrder
                }
                return order
            })

            // TODO Sync to server
        } else {
            // TODO thông báo lỗi cho khách hàng
            console.log("Có lỗi khi lựa chọn sản phẩm. Vui lòng thử lại")
        }
    },

    REMOVE_ITEM_FROM_ORDER(state, item) {

    },

    UPDATE_SELECTED_ORDER_ID(state, payload) {
        state.selectedOrderId = payload
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
        commit('REMOVE_ORDER_ITEMS', orderItem)
    },

    /**
     * Thêm 1 hàng hóa vào 1 hóa đơn
     * @param commit
     * @param orderItem
     * @param item
     */
    addItemToOrder({ commit }, item) {
        commit('ADD_ITEM_TO_ORDER', item)
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

    },

    updateSelectedOrderId({ commit }, id) {
        commit('UPDATE_SELECTED_ORDER_ID', id)
    }
}

const getters = {
    orders: state => state.orders,
    totalPriceByOrderId: (state) => (orderId) => {
        // TODO tính tổng tiền cho 1 hóa đơn
    },
    quantityByOrderId: (state) => (orderId) => {
        // TODO tính tổng số hàng hóa cho 1 hóa đơn
    },
    selectedId: state => state.selectedOrderId,
    currentOrder: state => {
        return state.orders.find(
            order => order.id === state.selectedOrderId
        )
    }
}

const orderModule = {
    state, mutations, actions, getters
}

export default orderModule