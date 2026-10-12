import { Link } from '@inertiajs/react'
import { PageHeader } from '@/components/shared/business-form'
import { money } from '@/types/business'

type Balance = { id: number | null; name: string; phone: string | null; count: number; balance: string }
export default function Debts({ receivable, payable, customers, suppliers }: { receivable: string | null; payable: string | null; customers: Balance[]; suppliers: Balance[] }) {
  return <>
    <PageHeader title="Công nợ" subtitle="Theo dõi số tiền còn phải thu và phải trả trên các chứng từ đã chốt." />
    <div className="mb-6 grid gap-4 sm:grid-cols-2">
      {receivable !== null && <section className="pv-panel p-6"><p className="text-sm text-muted-foreground">Khách hàng còn phải trả</p><p className="mt-3 text-3xl font-semibold text-primary tabular-nums">{money(receivable)}</p><Link href="/manage/invoices?unpaid=true" className="mt-3 inline-block text-sm text-primary">Xem hóa đơn còn nợ</Link></section>}
      {payable !== null && <section className="pv-panel p-6"><p className="text-sm text-muted-foreground">Còn phải trả nhà cung cấp</p><p className="mt-3 text-3xl font-semibold tabular-nums">{money(payable)}</p><Link href="/manage/purchases?unpaid=true" className="mt-3 inline-block text-sm text-primary">Xem phiếu nhập còn nợ</Link></section>}
    </div>
    <div className="grid gap-6 xl:grid-cols-2">
      {receivable !== null && <BalanceTable title="Phải thu từ khách hàng" rows={customers} resource="invoices" />}
      {payable !== null && <BalanceTable title="Phải trả nhà cung cấp" rows={suppliers} resource="purchases" />}
    </div>
  </>
}
function BalanceTable({ title, rows, resource }: { title: string; rows: Balance[]; resource: string }) {
  return <section className="pv-panel overflow-hidden"><h2 className="border-b p-5 font-semibold">{title}</h2><div className="overflow-x-auto"><table className="pv-table"><thead><tr><th>Đối tác</th><th>Chứng từ</th><th className="text-right">Còn nợ</th></tr></thead><tbody>{rows.map(row => <tr key={row.id ?? 'anonymous'}><td><p className="font-medium">{row.name}</p><p className="mt-1 text-xs text-muted-foreground">{row.phone}</p></td><td><Link className="text-primary" href={`/manage/${resource}?unpaid=true${row.id ? `&partner_id=${row.id}` : ''}`}>{row.count} chứng từ</Link></td><td className="text-right font-medium tabular-nums">{money(row.balance)}</td></tr>)}</tbody></table></div>{!rows.length && <p className="pv-empty">Không có công nợ.</p>}</section>
}
