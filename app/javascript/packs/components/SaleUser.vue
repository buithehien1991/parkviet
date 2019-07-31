<template>
    <div class="sale-user d-flex mt-2">
        <div class="mr-auto">
            <i class="fa fa-user-circle-o"></i>
        </div>

        <div>
            {{ this.time | dateFormat("DD/MM/YYYY h:mm") }}
        </div>
    </div>
</template>

<script>
    export default {
        name: "SaleUser",

        data () {
            const time = Date.now()

            return {
                time: time
            }
        }
    }
</script>

<style scoped>

</style>