<template>
    <div>
        <a :class="['chevron-btn', {active: showProductList}]" title="Thu gọn" id="chevron-btn" @click.stop="toggleProductList()">
            <i id="chevron-fa-icon" :class="['fa text-white', showProductList ? 'fa-chevron-down' : 'fa-chevron-up']"></i>
        </a>

        <div class="product-list">
            <div class="action-toolbar"></div>
            <div class="row" style="margin: 0 10px;">
                <div v-for="product in products" class="card" style="margin: 10px; width: 110px;">
                    <ProductListItem :product="product"></ProductListItem>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import { mapGetters } from 'vuex'
    import ProductListItem from "./ProductListItem"
    export default {
        name: "ProductList",
        components: {ProductListItem},
        computed: {
            ...mapGetters(['showProductList', 'products'])
        },
        methods: {
            toggleProductList() {
                this.$store.dispatch('updateShowProductList', !showProductList)
            }
        }
    }
</script>

<style scoped>

</style>