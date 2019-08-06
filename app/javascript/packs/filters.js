import moment from 'moment'
import formatMoney from 'accounting-js/lib/formatMoney.js'
import unformat from 'accounting-js/lib/unformat.js'

export function date(value) {
    return moment(value).format('L')
}

export function dateFormat(value, format) {
    return moment(value).format(format)
}

export function priceFormat(value) {
    return formatMoney(value, { symbol: "", precision: 0, thousand: ".", decimal: "," })
}

export function priceUnformat(value) {
    return unformat(value)
}

/**
 * Formats a percentage. Ex: .12 => '12%'
 *
 * @export
 * @param {number} value
 * @returns
 */
export function percentage(value) {
    return `${Math.round(value * 100).toLocaleString()}%`
}

/**
 * Formats an amount of dollars using number localization. Ex: 15.05 => '$15.05'
 *
 * @export
 * @param {number} value
 * @returns
 */
export function money (value) {
    return `$${value.toLocaleString()}`
}