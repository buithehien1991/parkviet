<template>
    <div class="">
        <div>
            <h5>THANH TOÁN</h5>
        </div>

        <div class="d-flex">
            <div class="mr-auto">
                Tổng số lượng hàng hóa
            </div>
            <div>
                {{ quantityByOrder }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto">
                Tổng tiền hàng
            </div>
            <div>
                {{ totalPriceByOrder }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto">
                Giảm giá
            </div>
            <div>
                {{ saleOff }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto font-weight-bold">
                Khách cần trả
            </div>
            <div class="paid-price">
                {{ totalPriceByOrder - saleOff }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto">
                Khách thanh toán (F8)
            </div>
            <div>
                <input type="text" :value="givenMoney" @input="updateGivenMoney">
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto ">
                Tiền thừa trả khách
            </div>
            <div>
                {{ returned_money }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div>
            Ghi chú
        </div>

        <div>
            <textarea class="form-control form-control-sm" name="note"></textarea>
        </div>
    </div>
</template>

<script>
    import { mapGetters } from 'vuex'
    export default {
        name: "Payment",
        computed: {
            ...mapGetters(['totalPriceByOrder', 'saleOff', 'quantityByOrder', 'givenMoney']),
            totalFinalPrice: function () {
                return this.totalPriceByOrder - this.saleOff
            },
            returned_money: function(){
                return this.givenMoney - this.totalFinalPrice
            }
        },
        methods: {
            updateGivenMoney(e) {
                this.$store.dispatch('updateGivenMoney', e.target.value)
            }
        }
    }
</script>

<style scoped>

</style>