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
                {{ totalPriceByOrder | priceFormat }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto">
                Giảm giá
            </div>
            <div>
                {{ saleOff | priceFormat }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto font-weight-bold">
                Khách cần trả
            </div>
            <div class="paid-price">
                {{ (totalPriceByOrder - saleOff) | priceFormat }}
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto">
                Khách thanh toán (F8)
            </div>
            <div>
                <vue-numeric currency="₫" separator="," v-model="giveMoney"></vue-numeric>
            </div>
        </div>

        <hr style="margin: 5px 0;">

        <div class="d-flex">
            <div class="mr-auto ">
                Tiền thừa trả khách
            </div>
            <div>
                {{ returned_money | priceFormat }}
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
    import VueNumeric from 'vue-numeric'
    export default {
        name: "Payment",
        computed: {
            ...mapGetters(['totalPriceByOrder', 'saleOff', 'quantityByOrder']),
            inputGivenMoney: false,
            giveMoney: {
                get() {
                    return this.$store.getters.givenMoney
                },
                set(value) {
                    this.$store.dispatch('updateGivenMoney', value)
                    console.log(value)
                }
            },
            totalFinalPrice: function () {
                return this.totalPriceByOrder - this.saleOff
            },
            returned_money: function(){
                return this.giveMoney - this.totalFinalPrice
            }
        },
        methods: {

        },
        components: {
            VueNumeric
        },
        watch: {
            totalFinalPrice: function (newValue, oldValue) {
                this.giveMoney = newValue
            }
        }
    }
</script>

<style scoped>

</style>