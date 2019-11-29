<template>
    <div>
        <div class="sale-user d-flex mt-2">
            <div class="mr-auto">
                <i class="fa fa-user-circle-o"></i> {{ user.fullname }}
            </div>

            <div>
                {{ this.time | dateFormat("DD/MM/YYYY h:mm") }}
            </div>
        </div>

        <div class="mt-2">
            <SaleCustomer></SaleCustomer>
        </div>

        <hr style="margin: 0.8rem -10px;">

        <Payment></Payment>

        <hr style="margin: 0.8rem -10px;">

        <button class="btn btn-park btn-lg w-100 text-white" @click="checkout">
            <i class="fa fa-shopping-cart"></i>
            Thanh toán
        </button>

        <b-modal id="modal-checkout-success" title="Thanh toán" @ok="closeOrder">
            <p class="my-4 text-success">Đã thanh toán thành công, bạn có muốn đóng hóa đơn này không ?, </p>
        </b-modal>
    </div>
</template>

<script>
    import SaleCustomer from './SaleCustomer'
    import Payment from "./Payment"
    export default {
        name: "SaleUser",
        props: ['user'],
        data () {
            const time = Date.now()

            return {
                time: time
            }
        },
        components: {
            Payment,
            SaleCustomer
        },
        methods: {
            checkout() {
                this.$store.dispatch('checkout').then(() => {
                    //  Show dialog đã thanh toán thành công. bạn có muốn đóng hóa đơn này không ?
                    this.$bvModal.show("modal-checkout-success")
                    // In hóa đơn ???
                })
            },
            closeOrder() {
                this.$store.dispatch('closeCheckoutOrder')
            }
        }
    }
</script>

<style scoped lang="scss">
</style>