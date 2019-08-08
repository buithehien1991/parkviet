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
        let currentOrder = state.orders.find(
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

            let newOrderProductItem = {}
            Object.assign(newOrderProductItem, item)
            if (!orderProductExists) {
                newOrderProductItem.quantity = 1
                newOrderProductItem.discount_percent = 0
                newOrderProductItem.discount_money = 0
                newOrderProductItem.final_price = item.sale_price
                currentOrderProducts.push(newOrderProductItem)
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
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            let currentOrderProducts = currentOrder.orderProducts
            currentOrderProducts.map((orderProduct) => {
                if (orderProduct.id === item.id && orderProduct.quantity > 1) {
                    orderProduct.quantity--;
                } else if (orderProduct.id === item.id && orderProduct.quantity === 1){
                    const indexToRemove = currentOrderProducts.findIndex(orderProduct => orderProduct.id === item.id)
                    currentOrderProducts.splice(indexToRemove, 1)
                }
            })

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

        }
    },

    REMOVE_ALL_ITEM_FROM_ORDER(state, item) {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            const indexToRemove = currentOrder.orderProducts.findIndex(orderProduct => orderProduct.id === item.id)
            currentOrder.orderProducts.splice(indexToRemove, 1)

            state.orders = state.orders.map((order) => {
                if (order.id === state.selectedOrderId) {
                    order = currentOrder
                }
                return order
            })
        } else {
            // TODO thông báo lỗi cho khách hàng
            console.log("Có lỗi khi bỏ toàn bộ sản phẩm. Vui lòng thử lại")
        }
    },

    UPDATE_SELECTED_ORDER_ID(state, payload) {
        state.selectedOrderId = payload
    },

    UPDATE_GIVEN_MONEY(state, payload) {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            currentOrder.given_money = payload

            state.orders = state.orders.map((order) => {
                if (order.id === state.selectedOrderId) {
                    order = currentOrder
                }
                return order
            })
        }
        else {
            // TODO thông báo lỗi cho khách hàng
            console.log("Có lỗi khi cập nhật số tiền khách hàng đưa")
        }
    },

    CHECKOUT(state) {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            let data = currentOrder
            axios.post(config.INVOICES_PATH, data).then((response) => {
                // TODO làm gì nhỉ không biết @_@
            });
        } else {
            // TODO thông báo lỗi cho khách hàng
            console.log("Có lỗi xảy ra khi thanh toán. Vui lòng thử lại")
        }
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
    removeItemFromOrder({ commit }, item) {
        commit('REMOVE_ITEM_FROM_ORDER', item)
    },

    /**
     * Xóa tất cả hàng xóa trong 1 hóa đơn. Nhưng không xóa hóa đơn.
     * @param commit
     * @param orderItem
     */
    removeAllItemFromOrder({ commit }, orderItem) {
        commit('REMOVE_ALL_ITEM_FROM_ORDER', orderItem)
    },

    updateSelectedOrderId({ commit }, id) {
        commit('UPDATE_SELECTED_ORDER_ID', id)
    },

    updateGivenMoney({ commit }, giveMoney) {
        commit('UPDATE_GIVEN_MONEY', giveMoney)
    },

    checkout({ commit }) {
        commit('CHECKOUT')
    }
}

const getters = {
    orders: state => state.orders,
    totalPriceByOrder: state => {
        console.log(state)
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )

        if (currentOrder) {
            return currentOrder.orderProducts.reduce((acc, orderProduct) => {
                return (orderProduct.quantity * orderProduct.sale_price) + acc
            }, 0)
        } else {
            return 0
        }
    },
    saleOff: state => {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )

        if (currentOrder) {
            return currentOrder.orderProducts.reduce((acc, orderProduct) => {
                return (orderProduct.discount_money + acc)
            }, 0)
        } else {
            return 0
        }
    },
    totalFinalPriceByOrder: state => {

    },
    quantityByOrder: state => {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )

        if (currentOrder) {
            return currentOrder.orderProducts.reduce((acc, orderProduct) => {
                return (orderProduct.quantity + acc)
            }, 0)
        } else {
            return 0
        }
    },
    selectedId: state => state.selectedOrderId,
    currentOrder: state => {
        return state.orders.find(
            order => order.id === state.selectedOrderId
        )
    },
    givenMoney: state => {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            return currentOrder.given_money
        } else {
            return 0
        }
    }
}

const orderModule = {
    state, mutations, actions, getters
}

export default orderModule