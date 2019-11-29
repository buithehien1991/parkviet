import axios from 'axios'
import config from '../../../config'
import stringInject from 'stringinject';

const state = {
    type: 'new',
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

    UPDATE_TYPE(state, payload) {
        state.type = payload
    },

    GET_INVOICE_FROM_SERVER(state, payload) {
        let id, time, title
        if (state.type === 'edit') {
            id = payload.id
            time = payload.time
            title = payload.code ? payload.code : payload.id
            title = "UPDATE_" + title
        } else {
            // Copy
            id = Date.now()
            time = Date.now()
            title = payload.code ? payload.code : payload.id
            title = "COPY_" + title
        }

        let orderProducts = []

        for (let i = 0; i < payload.product_invoices.length; i++) {
            let pi = payload.product_invoices[i]
            let newOrderProductItem = {}
            Object.assign(newOrderProductItem, pi.product)
            newOrderProductItem.id = pi.product_id

            newOrderProductItem.quantity = pi.quantity
            newOrderProductItem.discount_percent = pi.discount_percent
            newOrderProductItem.discount_money = pi.discount_money
            newOrderProductItem.sale_price = pi.unit_price
            newOrderProductItem.final_price = pi.final_price

            orderProducts.push(newOrderProductItem)
        }

        let order = {}
        if (state.type === 'edit') {
            order = {
                id: id,
                title: title,
                number: 1,
                orderProducts: orderProducts,
                total_price: payload.total_price ? payload.total_price : 0,
                sale_off: payload.sale_off ? payload.sale_off : 0,
                paid: payload.paid ? payload.paid : 0,
                given_money: payload.given_money ? payload.given_money : 0,
                returned_money: payload.returned_money ? payload.returned_money : null,
                note: payload.note ? payload.note : "",
                created: time,

                // Other field
                code: payload.code,
                customer_id: payload.customer_id,
                payment_method: payload.payment_method,
                seller_id: payload.seller_id,
                final_price: payload.final_price,
                time: payload.time,
                date: payload.date
            }
        } else {
            order = {
                id: String(id),
                title: title,
                number: 1,
                orderProducts: orderProducts,
                total_price: 0,
                sale_off: 0,
                paid: 0,
                given_money: 0,
                returned_money: null,
                note: "",
                created: time,
            }
        }

        state.orders = []
        state.orders.push(order)
        state.selectedOrderId = id
    },

    CHECKOUT(state) {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        if (currentOrder) {
            let data = {invoice: currentOrder}
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
        commit('UPDATE_ORDER_ITEMS', [])
    },

    getInvoiceFromServer({ commit, rootState }, order_id) {
        let url = stringInject(config.INVOICE_PATH, {id: order_id})
        axios.get(url).then((response) => {
            commit('GET_INVOICE_FROM_SERVER', response.data)
            console.log(response)
        }).catch(error => {
            console.log(error)
        });
    },

    addNewOrder({ commit }) {
        const time = Date.now()
        let id = String(time)
        const order = {
            id: id,
            title: 'Hóa đơn ' + this.nextNumber,
            number: this.nextNumber,
            orderProducts: [],
            total_price: 0,
            sale_off: 0,
            paid: 0,
            given_money: 0,
            returned_money: null,
            note: "",
            created: time,
        }

        commit('ADD_ORDER_ITEMS', order)
        commit('UPDATE_SELECTED_ORDER_ID', id)
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
    
    removeCurrentOrde({ commit }) {
        let currentOrder = state.orders.find(
            order => order.id === state.selectedOrderId
        )
        commit('REMOVE_ORDER_ITEMS', currentOrder)
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

    updateType({ commit }, type) {
        commit('UPDATE_TYPE', type)
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