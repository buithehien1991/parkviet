<template>
    <div class="new-tab">
        <ul class="nav nav-tabs">
            <li v-for="order of orders" class="nav-item">
                <a :class="['nav-link', {active: order === selectedOrder}]" @click="selectOrder(order)">{{ order.title }}</a>
            </li>

            <li class="nav-item ml-2">
                <button @click="addOrder" class="btn btn-success" ><i class="fa fa-plus"></i></button>
            </li>
        </ul>
    </div>
</template>

<script>
    export default {
        data () {
            return {
                orders: [],
                selectedId: null
            }
        },

        computed: {
            selectedOrder () {
                return this.orders.find(order => order.id === this.selectedId)
            }
        },

        watch: {
            handler: 'saveOrders',
            deep: true
        },

        methods: {
            addOrder () {
                const time = Date.now()

                const order = {
                    id: String(time),
                    title: 'Hóa đơn ' + (this.orders.length + 1),
                    created: time
                }

                this.orders.push(order)
                this.selectOrder(order)
            },
            removeOrder () {

            },
            selectOrder (order) {
                this.selectedId = order.id
            },

            saveOrders () {

            }
        }
    }
</script>