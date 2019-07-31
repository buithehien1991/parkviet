import moment from 'moment'

export function date(value) {
    return moment(value).format('L')
}

export function dateFormat(value, format) {
    return moment(value).format(format)
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