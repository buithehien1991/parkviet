<template>
    <div>
        <div>
            <div class="navbar-container">
                <SaleHeader />
            </div>

            <div class="sale-container">
                <div class="wrap-container">
                    <div class="col-right">
                        <SaleUser :user="user"/>
                    </div>
                    <div :class="['col-left', {active: !showProductList}]">
                        <div class="product-cart">
                            <NewTab />

                            <OrderProductList></OrderProductList>
                        </div>

                        <ProductList />

                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    import SaleUser from "./packs/components/SaleUser"
    import Loading from 'vue-loading-overlay';
    import SaleHeader from "./packs/components/SaleHeader"
    import NewTab from "./packs/components/NewTab"
    import ProductList from "./packs/components/ProductList"
    import OrderProductList from './packs/components/OrderProductList'
    import { mapGetters } from 'vuex'

    export default {
        name: 'home',
        components: {ProductList, NewTab, SaleHeader, Loading, SaleUser, OrderProductList},
        computed: {
            ...mapGetters(['showProductList', 'user'])
        },
        created() {
            this.$store.dispatch('getProductItems')
            this.$store.dispatch('getUserInfo')
            this.$store.dispatch('getOrderItems')
            this.$store.dispatch('getCustomers')
        },
        mounted() {
            console.log(this.$route)

            if (this.$route && this.$route.query.invoice && !this.$route.query.from_invoice) {
                this.$store.dispatch('updateType', 'edit')
                this.$store.dispatch('getInvoiceFromServer', this.$route.query.invoice)
            } else if (this.$route&& !this.$route.query.invoice && this.$route.query.from_invoice) {
                this.$store.dispatch('updateType', 'copy')
                this.$store.dispatch('getInvoiceFromServer', this.$route.query.from_invoice)
            }
        }
    }
</script>