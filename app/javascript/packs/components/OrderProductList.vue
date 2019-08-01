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
                            {{ orderProduct.quantity }}
                            <span>
                                <i @click="addCartItem(cartItem)"
                                   class="fa fa-arrow-circle-up cart-item__modify"></i>
                                <i @click="removeCartItem(cartItem)"
                                   class="fa fa-arrow-circle-down cart-item__modify"></i>
                            </span>
                        </td>
                        <td>{{ orderProduct.sale_price }}</td>
                        <td>{{ orderProduct.quantity * orderProduct.sale_price }}</td>
                        <td>
                            <a href="#" @click="">
                                <i class="fa fa-plus-circle"></i>
                            </a>

                            <a href="#">
                                <i class="fa fa-minus-circle"></i>
                            </a>

                            <a href="#">
                                <i class="fa fa-cart-arrow-down"></i>
                            </a>

                            <a href="#">
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
        }
    }
</script>

<style scoped>
.cart-item__modify {
    cursor: pointer;
}
</style>