<template>
    <div class="">
        <div>
            <h5>THANH TOÁN</h5>
        </div>

        <div class="d-flex">
            <div class="mr-auto">
                Tổng tiền hàng
            </div>
            <div>
                {{ totalPriceByOrder }}
            </div>
        </div>

        <div class="d-flex">
            <div class="mr-auto">
                Giảm giá
            </div>
            <div>
                {{ saleOff }}
            </div>
        </div>

        <div class="d-flex">
            <div class="mr-auto font-weight-bold">
                Khách cần trả
            </div>
            <div class="paid-price">
                100,000
            </div>
        </div>

        <div class="d-flex">
            <div class="mr-auto">
                Khách thanh toán (F8)
            </div>
            <div>

            </div>
        </div>

        <div class="d-flex">
            <div class="mr-auto ">
                Tiền thừa trả khách
            </div>
            <div>
                100,000
            </div>
        </div>

        <div>
            Ghi chú
        </div>
        <div>

        </div>
    </div>
</template>

<script>
    import { mapGetters } from 'vuex'
    export default {
        name: "Payment",
        computed: {
            ...mapGetters(['totalPriceByOrder', 'saleOff'])
        }
    }
</script>

<style scoped>

</style>