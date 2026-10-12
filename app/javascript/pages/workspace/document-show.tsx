import { Link, router, useForm, usePage } from '@inertiajs/react'
import { useState, type CSSProperties } from 'react'
import { Printer } from 'lucide-react'
import { Errors, FormField, PageHeader } from '@/components/shared/business-form'
import { money, statusLabel, type Document } from '@/types/business'

type Payment = { id: number; amount: string; date: string; payment_method: string; note: string | null; user_name: string }
type Receiving = { lines: { product_name: string; ordered: string; received: string; remaining: string; unit: string }[]; purchases: Document[] }
type Props = { document: Document; resource: string; title: string; store_details: { name: string; phone?: string; address?: string; tax?: string }; print_template?: { size: string; header?: string; footer?: string } | null; can_edit: boolean; can_delete: boolean; can_create: boolean; can_approve: boolean; can_receive: boolean; payment_request_key: string; current_date: string; payments: Payment[]; receiving: Receiving | null }
const paymentLabel = (value: string) => ({ cash: 'Tiền mặt', transfer: 'Chuyển khoản', card: 'Thẻ' }[value] || value)
export default function DocumentShow({ document, resource, title, store_details: store, print_template, can_edit, can_delete, can_create, can_approve, can_receive, payment_request_key, current_date, payments, receiving }: Props) {
  const base = `/manage/${resource}/${document.id}`
  const { props } = usePage<{ errors?: Record<string, string> }>()
  const [showPayment, setShowPayment] = useState(false)
  const balance = Number(document.final_price || 0) - Number(document.paid || 0)
  const finalized = ['completed', 'purchased'].includes(document.status || '') && resource !== 'purchase_orders'
  const form = useForm({ payment: { amount: String(Math.max(balance, 0)), payment_method: 'cash', date: current_date, note: '', request_key: payment_request_key } })
  const receiptWidth = { a4: '210mm', a5: '148mm', k80: '80mm', k58: '58mm' }[print_template?.size || 'a4']
  return <>
    <div className="pv-no-print">
      <PageHeader title={`${title} ${document.code}`} subtitle={statusLabel(document.status)}>
        <Link href={`/manage/${resource}`} className="pv-button-secondary">Quay lại</Link>
        <button className="pv-button-secondary" onClick={() => window.print()}><Printer size={16} />In chứng từ</button>
        {can_create && <Link className="pv-button-secondary" href={`/manage/${resource}/new?copy_from=${document.id}`}>Sao chép</Link>}
        {document.status === 'created' && can_edit && <Link className="pv-button-secondary" href={`${base}/edit`}>Sửa nháp</Link>}
        {resource === 'purchase_orders' && document.status === 'created' && can_approve && <button className="pv-button" onClick={() => router.post(`${base}/status`, { transition: 'approve' })}>Phê duyệt</button>}
        {resource === 'purchase_orders' && document.status === 'approved' && can_receive && <Link className="pv-button" href={`/manage/purchases/new?purchase_order_id=${document.id}`}>Nhận hàng / tạo phiếu nhập</Link>}
        {can_edit && document.status === 'created' && resource !== 'purchase_orders' && <button className="pv-button" onClick={() => router.post(`${base}/status`, { transition: 'complete' })}>Chốt chứng từ</button>}
        {can_edit && finalized && balance > 0 && <button className="pv-button" onClick={() => setShowPayment(!showPayment)}>{resource === 'invoices' ? 'Thu tiền' : 'Thanh toán nhà cung cấp'}</button>}
        {can_delete && document.status !== 'canceled' && <button className="pv-button-secondary text-destructive" onClick={() => { if (window.confirm('Hủy chứng từ và hoàn lại tồn kho? Tiền đã thu / chi không tự hoàn trả; hãy xử lý hoàn tiền thực tế riêng.')) router.delete(base) }}>Hủy</button>}
      </PageHeader>
      <Errors errors={props.errors || {}} />
      {showPayment && <form className="pv-panel mb-6 grid gap-5 p-6 sm:grid-cols-2 lg:grid-cols-4" onSubmit={event => { event.preventDefault(); form.post(`${base}/payment`, { onSuccess: () => { setShowPayment(false); form.setData('payment', { ...form.data.payment, request_key: crypto.randomUUID() }) } }) }}>
        <FormField field={{ key: 'amount', label: `Số tiền (còn nợ ${money(balance)})`, type: 'number', required: true }} value={form.data.payment.amount} onChange={value => form.setData('payment', { ...form.data.payment, amount: value })} />
        <FormField field={{ key: 'method', label: 'Phương thức', type: 'select', options: ['cash', 'transfer', 'card'].map(value => ({ value, label: paymentLabel(value) })) }} value={form.data.payment.payment_method} onChange={value => form.setData('payment', { ...form.data.payment, payment_method: value })} />
        <FormField field={{ key: 'date', label: 'Ngày thu / chi', type: 'date', required: true }} value={form.data.payment.date} onChange={value => form.setData('payment', { ...form.data.payment, date: value })} />
        <FormField field={{ key: 'note', label: 'Ghi chú', type: 'text' }} value={form.data.payment.note} onChange={value => form.setData('payment', { ...form.data.payment, note: value })} />
        <div className="sm:col-span-2 lg:col-span-4"><button className="pv-button" disabled={form.processing || Number(form.data.payment.amount) <= 0 || Number(form.data.payment.amount) > balance}>Xác nhận khoản tiền thực tế</button></div>
      </form>}
      {receiving && <section className="pv-panel mb-6 overflow-hidden"><h2 className="border-b p-5 font-semibold">Tiến độ nhận hàng</h2><div className="overflow-x-auto"><table className="pv-table"><thead><tr><th>Sản phẩm</th><th>Đã đặt</th><th>Đã nhập</th><th>Còn thiếu</th></tr></thead><tbody>{receiving.lines.map(line => <tr key={line.product_name}><td>{line.product_name}</td><td>{line.ordered} {line.unit}</td><td>{line.received}</td><td>{line.remaining}</td></tr>)}</tbody></table></div>{receiving.purchases.length > 0 && <div className="flex flex-wrap gap-3 border-t p-5">{receiving.purchases.map(purchase => <Link key={purchase.id} href={`/manage/purchases/${purchase.id}`} className="text-sm text-primary">{purchase.code} · {statusLabel(purchase.status)}</Link>)}</div>}</section>}
    </div>
    <article className="pv-panel pv-receipt mx-auto max-w-4xl p-6 sm:p-10" style={{ '--receipt-width': receiptWidth } as CSSProperties}>
      <header className="mb-8 border-b pb-6 text-center"><h2 className="text-2xl font-semibold">{store.name}</h2><p className="mt-2 text-sm text-muted-foreground">{store.address} {store.phone}</p>{store.tax && <p className="text-sm">Mã số thuế: {store.tax}</p>}{print_template?.header && <p className="mt-3 whitespace-pre-wrap text-sm">{print_template.header}</p>}<h3 className="mt-6 text-xl font-semibold uppercase">{title}</h3><p className="mt-2 text-sm">{document.code} · {document.date}</p><p className="mt-2 text-sm">{resource === 'invoices' ? 'Khách hàng' : 'Nhà cung cấp'}: {document.partner_name || (resource === 'invoices' ? 'Khách lẻ' : 'Chưa chọn')}</p></header>
      <div className="overflow-x-auto"><table className="pv-table"><thead><tr><th>Sản phẩm</th><th>SL</th><th>Đơn giá</th><th>Giảm giá</th><th className="text-right">Thành tiền</th></tr></thead><tbody>{document.lines.map((line, index) => <tr key={index}><td>{line.product_name}</td><td>{line.quantity} {line.unit}</td><td>{money(line.unit_price)}</td><td>{money(line.discount_money)}</td><td className="text-right">{money(line.final_price)}</td></tr>)}</tbody></table></div>
      <dl className="ml-auto mt-6 max-w-sm space-y-3 text-sm">{[['Tổng tiền hàng', document.total_price], ['Giảm giá', document.discount_money], ['Thành tiền', document.final_price], ['Đã thanh toán', document.paid], ['Còn phải trả', balance], ['Tiền khách đưa lúc bán', document.given_money], ['Tiền thừa lúc bán', document.returned_money]].map(([label, value]) => <div key={String(label)} className="flex justify-between gap-5"><dt>{label}</dt><dd className="font-medium tabular-nums">{money(value)}</dd></div>)}</dl>
      {document.note && <p className="mt-6 whitespace-pre-wrap border-t pt-4 text-sm">Ghi chú: {document.note}</p>}{print_template?.footer && <p className="mt-8 whitespace-pre-wrap text-center text-sm">{print_template.footer}</p>}
    </article>
    {payments.length > 0 && <section className="pv-panel pv-no-print mt-6 overflow-hidden"><h2 className="border-b p-5 font-semibold">Lịch sử thu / chi</h2><div className="overflow-x-auto"><table className="pv-table"><thead><tr><th>Ngày</th><th>Số tiền</th><th>Phương thức</th><th>Người ghi nhận</th><th>Ghi chú</th></tr></thead><tbody>{payments.map(payment => <tr key={payment.id}><td>{payment.date}</td><td className="tabular-nums">{money(payment.amount)}</td><td>{paymentLabel(payment.payment_method)}</td><td>{payment.user_name}</td><td>{payment.note || '—'}</td></tr>)}</tbody></table></div></section>}
  </>
}
