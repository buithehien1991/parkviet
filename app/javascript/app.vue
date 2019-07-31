<template>
  <div>
    <div>
      <div class="navbar-container">
        <SaleHeader />
      </div>

      <div class="sale-container">
        <div class="wrap-container">
          <div class="col-right">
            <SaleUser />
          </div>
          <div :class="['col-left', {active: true}]">
            <div class="product-cart">
              <NewTab />
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

    export default {
      components: {ProductList, NewTab, SaleHeader, Loading, SaleUser},
      created() {
        this.$store.dispatch('getProductItems')
        this.$store.dispatch('getUserInfo')
        this.$store.dispatch('getOrderItems')
      }
    }
</script>