<template>
  <div>
    <loading v-if="remoteDataBusy" :active.sync="remoteDataBusy"
             :can-cancel="true"
             :is-full-page="true"></loading>

    <div v-else>
      <div class="navbar-container">
        <SaleHeader :user="user" />
      </div>

      <div class="sale-container">
        <div class="wrap-container">
          <div class="col-right">
            <SaleUser />
          </div>
          <div class="col-left">

          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
    import SaleUser from "./packs/components/SaleUser"
    import RemoteData from './packs/mixins/RemoteData'
    import Loading from 'vue-loading-overlay';
    import SaleHeader from "./packs/components/SaleHeader"

    export default {
        components: {SaleHeader, Loading, SaleUser},
        mixins: [
            RemoteData({
                user () {
                    return 'get_current_user'
                },
                products () {
                    return 'manage/products.json'
                }
            })
        ]
    }
</script>