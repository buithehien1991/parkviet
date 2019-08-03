<template>
    <div class="tab-content" id="cart-tabs-content">
        <div class="tab-pane fade show active" id="page1" role="tabpanel" aria-labelledby="home-tab">
            <table class="table table-bordered">
                <thead>
                <th>STT</th>
                <th>Tên sản phẩm</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
                <th></th>
                </thead>
                <tbody>
                    <tr v-for="(orderProduct, index) in currentOrder.orderProducts">
                        <td>{{ index + 1 }}</td>
                        <td>{{ orderProduct.name }}</td>
                        <td>
                            <div class="d-flex justify-content-between">
                                <span>{{ orderProduct.quantity }}</span>
                                <span>
                                    <i @click="addItemToOrder(orderProduct)"
                                       class="fa fa-arrow-circle-up cart-item__modify"></i>
                                    <i @click="removeItemFromOrder(orderProduct)"
                                       class="fa fa-arrow-circle-down cart-item__modify"></i>
                                </span>
                            </div>
                        </td>
                        <td>{{ orderProduct.sale_price }}</td>
                        <td>
                            <div class="d-flex justify-content-between">
                                <span>{{ orderProduct.quantity * orderProduct.sale_price }}</span>
                                <span>
                                    <i class="fa fa-cart-arrow-down cart-item__modify"></i>
                                </span>
                            </div>

                        </td>
                        <td>
                            <a href="#" @click="removeAllItemFromOrder(orderProduct)">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </tbody>

            </table>
        </div>
    </div>
</template>

<script>
    import { mapGetters } from 'vuex'
    import OrderProductListItem from './OrderProductListItem'
    export default {
        name: "OrderProductList",
        computed: {
            ...mapGetters(['currentOrder']),
        },
        components: {
            OrderProductListItem
        },
        methods: {
            addItemToOrder(item) {
                this.$store.dispatch('addItemToOrder', item)
            },
            removeItemFromOrder(item) {
                this.$store.dispatch('removeItemFromOrder', item)
            },
            removeAllItemFromOrder(item) {
                this.$store.dispatch('removeAllItemFromOrder', item)
            }
        }
    }
</script>

<style scoped>
.cart-item__modify {
    cursor: pointer;
}
</style>