import { Link, router } from '@inertiajs/react'
import { useState } from 'react'
import { Plus, Search } from 'lucide-react'
import { PageHeader } from '@/components/shared/business-form'
import { money, statusLabel, type Document, type Option } from '@/types/business'

type Filters = { q?: string; status?: string; from?: string; to?: string; partner_id?: string; unpaid?: string }
type Props = { resource: string; title: string; documents: Document[]; can_create: boolean; can_edit: boolean; filters: Filters; statuses: string[]; partners: Option[]; pagination: { page: number; pages: number; count: number } }
export default function DocumentIndex({ resource, title, documents, can_create, can_edit, filters, statuses, partners, pagination }: Props) {
  const [search, setSearch] = useState({ q: filters.q || '', status: filters.status || '', from: filters.from || '', to: filters.to || '', partner_id: filters.partner_id || '', unpaid: filters.unpaid || '' })
  const base = `/manage/${resource}`
  return <>
    <PageHeader title={title} subtitle={`${pagination.count} chứng từ trong cửa hàng`}>{can_create && <Link className="pv-button" href={`${base}/new`}><Plus size={18} />Tạo chứng từ</Link>}</PageHeader>
    <section className="pv-panel overflow-hidden">
      <form className="grid items-end gap-3 border-b p-4 sm:grid-cols-2 xl:grid-cols-6" onSubmit={event => { event.preventDefault(); router.get(base, search, { preserveState: true }) }}>
        <label className="xl:col-span-2"><span className="pv-label">Mã hoặc tên chứng từ</span><input className="pv-input" placeholder="Tìm chứng từ…" value={search.q} onChange={event => setSearch({ ...search, q: event.target.value })} /></label>
        <label><span className="pv-label">Trạng thái</span><select className="pv-input" value={search.status} onChange={event => setSearch({ ...search, status: event.target.value })}><option value="">Tất cả</option>{statuses.map(status => <option key={status} value={status}>{statusLabel(status)}</option>)}</select></label>
        <label><span className="pv-label">Đối tác</span><select className="pv-input" value={search.partner_id} onChange={event => setSearch({ ...search, partner_id: event.target.value })}><option value="">Tất cả</option>{partners.map(partner => <option key={partner.id} value={partner.id}>{partner.name}</option>)}</select></label>
        <label><span className="pv-label">Từ ngày</span><input className="pv-input" type="date" value={search.from} onChange={event => setSearch({ ...search, from: event.target.value })} /></label>
        <label><span className="pv-label">Đến ngày</span><input className="pv-input" type="date" value={search.to} onChange={event => setSearch({ ...search, to: event.target.value })} /></label>
        <div className="flex flex-wrap items-center gap-3 sm:col-span-2 xl:col-span-6">
          {resource !== 'purchase_orders' && <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={search.unpaid === 'true'} onChange={event => setSearch({ ...search, unpaid: event.target.checked ? 'true' : '' })} />Chỉ chứng từ còn nợ</label>}
          <button className="pv-button-secondary"><Search size={16} />Lọc chứng từ</button><Link href={base} className="pv-button-quiet">Xóa bộ lọc</Link>
        </div>
      </form>
      <div className="overflow-x-auto"><table className="pv-table"><thead><tr><th>Mã / tên</th><th>Ngày</th><th>Đối tác</th><th>Trạng thái</th><th className="text-right">Thành tiền</th><th className="text-right">Đã trả</th><th className="text-right">Còn nợ</th><th /></tr></thead><tbody>{documents.map(document => <tr key={document.id}>
        <td><Link className="font-medium text-primary" href={`${base}/${document.id}`}>{document.code}</Link>{document.name && <p className="mt-1 text-xs text-muted-foreground">{document.name}</p>}</td><td>{document.date}</td><td>{document.partner_name || (resource === 'invoices' ? 'Khách lẻ' : 'Chưa chọn')}</td><td>{statusLabel(document.status)}</td><td className="text-right tabular-nums">{money(document.final_price)}</td><td className="text-right tabular-nums">{money(document.paid)}</td><td className="text-right tabular-nums">{['completed', 'purchased'].includes(document.status || '') && resource !== 'purchase_orders' ? money(Number(document.final_price) - Number(document.paid)) : '—'}</td><td>{can_edit && document.status === 'created' && <Link href={`${base}/${document.id}/edit`} className="pv-button-quiet">Sửa</Link>}</td>
      </tr>)}</tbody></table>{!documents.length && <p className="pv-empty">Chưa có chứng từ phù hợp. Tạo chứng từ hoặc thay đổi bộ lọc.</p>}</div>
      <footer className="flex items-center justify-between border-t p-4 text-sm"><span className="text-muted-foreground">Trang {pagination.page} / {pagination.pages}</span><div className="flex gap-2"><button className="pv-button-secondary" disabled={pagination.page <= 1} onClick={() => router.get(base, { ...filters, page: pagination.page - 1 })}>Trước</button><button className="pv-button-secondary" disabled={pagination.page >= pagination.pages} onClick={() => router.get(base, { ...filters, page: pagination.page + 1 })}>Sau</button></div></footer>
    </section>
  </>
}
