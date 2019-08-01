<template>
    <div @click="addProductToOrder(product)" class="product-list-item">
        <img :src="product.avatar_url" class="card-img-top product-img">
        <span class="product-price">{{ product.sale_price }}</span>
        <div class="card-body">
            <p class="card-text">{{ product.name }}</p>
        </div>
    </div>
</template>

<script>
    export default {
        name: "Product",
        props: ['product'],
        computed: {

        },
        methods: {
            addProductToOrder(product) {
                this.$store.dispatch('addItemToOrder', product)
            }
        }
    }
</script>

<style scoped>
</style>