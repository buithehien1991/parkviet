<template>
    <div>
        <a :class="['chevron-btn', {active: this.$state.showProductList}]" title="Thu gọn" id="chevron-btn" @click.stop="toggleProductList()">
            <i id="chevron-fa-icon" :class="['fa text-white', this.$state.showProductList ? 'fa-chevron-down' : 'fa-chevron-up']"></i>
        </a>

        <div class="product-list">
            <div class="action-toolbar"></div>

        </div>
    </div>
</template>

<script>
    export default {
        name: "ProductList",
        methods: {
            toggleProductList() {
                this.$state.showProductList = !this.$state.showProductList
            }
        }
    }
</script>

<style scoped>

</style>