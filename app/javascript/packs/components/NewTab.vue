<template>
    <div class="new-tab">
        <ul class="nav nav-tabs">
            <li v-for="order of orders" class="nav-item">
                <a :class="['nav-link', {active: order === selectedOrder}]" @click="selectOrder(order)">
                    {{ order.title }}
                    <button type="button" class="close" aria-label="Close" @click.stop="removeOrder(order)">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </a>
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
                selectedId: null,
            }
        },

        computed: {
            selectedOrder () {
                return this.orders.find(order => order.id === this.selectedId)
            },
            nextNumber() {
                if (this.orders.length === 0) {
                    return 1;
                }

                return Math.max.apply(Math, this.orders.map(function(o) { return o.number; })) + 1
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
                    title: 'Hóa đơn ' + this.nextNumber,
                    number: this.nextNumber,
                    created: time
                }

                this.orders.push(order)
                this.selectOrder(order)
            },
            removeOrder (order) {
                const index = this.orders.indexOf(order)
                if (index !== -1) {
                    this.orders.splice(index, 1)
                    if (this.orders.length > 0) {
                        this.selectOrder(this.orders[this.orders.length - 1])
                    }
                }
            },
            selectOrder (order) {
                this.selectedId = order.id
            },

            saveOrders () {

            }
        }
    }
</script>