import { Link, router } from '@inertiajs/react'
import { useState } from 'react'
import { Plus, Search } from 'lucide-react'
import { PageHeader } from '@/components/shared/business-form'
import { money, statusLabel, type BusinessRecord, type Field } from '@/types/business'

type Props = { resource: string; title: string; records: BusinessRecord[]; fields: Field[]; query: string; pagination: { page: number; pages: number; count: number }; can_create: boolean; can_edit: boolean; can_delete: boolean }
export default function ResourceIndex({ resource, title, records, fields, query, pagination, can_create, can_edit, can_delete }: Props) {
  const [search, setSearch] = useState(query)
  const base = `/manage/${resource}`
  function display(record: BusinessRecord, field: Field) {
    const value = record[field.key]
    if (field.key.includes('price')) return money(Number(value || 0))
    if (field.key === 'status') return statusLabel(String(value || ''))
    return String(value ?? '—')
  }
  return <><PageHeader title={title} subtitle={`${pagination.count} bản ghi trong cửa hàng`}>{can_create && <Link className="pv-button" href={`${base}/new`}><Plus size={18} />Thêm mới</Link>}</PageHeader><section className="pv-panel overflow-hidden"><form onSubmit={event => { event.preventDefault(); router.get(base, { q: search }, { preserveState: true }) }} className="flex gap-3 border-b p-4"><label className="relative w-full max-w-md"><Search className="absolute left-3 top-3.5 text-muted-foreground" size={16} /><input aria-label="Tìm kiếm" className="pv-input pl-10" placeholder="Tìm theo tên, mã, điện thoại…" value={search} onChange={event => setSearch(event.target.value)} /></label><button className="pv-button-secondary">Tìm kiếm</button></form><div className="overflow-x-auto"><table className="pv-table"><thead><tr>{fields.map(field => <th key={field.key}>{field.label}</th>)}<th className="text-right">Thao tác</th></tr></thead><tbody>{records.map(record => <tr key={record.id}>{fields.map(field => <td key={field.key}>{display(record, field)}</td>)}<td><div className="flex justify-end gap-2"><Link className="pv-button-quiet" href={`${base}/${record.id}`}>Xem</Link>{can_edit && <Link className="pv-button-quiet" href={`${base}/${record.id}/edit`}>Sửa</Link>}{can_delete && <button className="pv-button-quiet text-destructive" onClick={() => { if (window.confirm('Xóa hoặc lưu trữ bản ghi này?')) router.delete(`${base}/${record.id}`) }}>Xóa</button>}</div></td></tr>)}</tbody></table>{!records.length && <p className="pv-empty">Chưa có dữ liệu phù hợp. Thêm bản ghi đầu tiên hoặc thử từ khóa khác.</p>}</div><footer className="flex items-center justify-between border-t p-4 text-sm"><span className="text-muted-foreground">Trang {pagination.page} / {pagination.pages}</span><div className="flex gap-2"><button className="pv-button-secondary" disabled={pagination.page <= 1} onClick={() => router.get(base, { q: search, page: pagination.page - 1 })}>Trước</button><button className="pv-button-secondary" disabled={pagination.page >= pagination.pages} onClick={() => router.get(base, { q: search, page: pagination.page + 1 })}>Sau</button></div></footer></section></>
}
