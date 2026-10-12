import { Link, useForm } from '@inertiajs/react'
import { Errors, FormField, PageHeader } from '@/components/shared/business-form'
import { money, statusLabel, type BusinessRecord, type Document, type Field } from '@/types/business'

type History = { resource: string; total: string; balance: string; count: number; documents: Document[] }
type Props = { resource: string; title: string; record: BusinessRecord; fields: Field[]; errors: Record<string, string>; readonly: boolean; images: string[]; can_edit: boolean; partner_history: History | null }
export default function ResourceForm({ resource, title, record, fields, errors, readonly, images, can_edit, partner_history: history }: Props) {
  const base = `/manage/${resource}`
  const initial = Object.fromEntries(fields.filter(field => field.type !== 'file').map(field => [field.key, record[field.key] ?? '']))
  const form = useForm({ record: initial as Record<string, string | number | boolean | null | File[]>, _method: record.id ? 'patch' : 'post' })
  return <>
    <PageHeader title={`${readonly ? 'Chi tiết' : 'Thêm / sửa'} ${title.toLowerCase()}`}>
      <Link className="pv-button-secondary" href={base}>Quay lại</Link>
      {readonly && can_edit && <Link className="pv-button" href={`${base}/${record.id}/edit`}>Sửa thông tin</Link>}
    </PageHeader>
    <section className="pv-panel max-w-4xl p-6"><Errors errors={errors} />
      <form onSubmit={event => { event.preventDefault(); form.post(record.id ? `${base}/${record.id}` : base, { forceFormData: true }) }}>
        <div className="grid gap-5 sm:grid-cols-2">{fields.map(field => field.type === 'file' ? <div key={field.key} className="sm:col-span-2">
          {!readonly && <><label htmlFor="product-images" className="pv-label">{field.label}</label><input id="product-images" className="pv-input" type="file" multiple accept="image/*" onChange={event => form.setData('record', { ...form.data.record, images: Array.from(event.target.files || []) })} /><p className="mt-2 text-xs text-muted-foreground">Ảnh mới được thêm vào các ảnh hiện có.</p></>}
          <div className="mt-4 flex flex-wrap gap-3">{images.map(image => <img key={image} src={image} alt="Ảnh sản phẩm" className="size-24 rounded-lg border object-cover" />)}</div>
        </div> : <FormField key={field.key} field={field} value={recordValue(form.data.record[field.key])} disabled={readonly} error={errors[field.key]} onChange={value => form.setData('record', { ...form.data.record, [field.key]: value })} />)}</div>
        {!readonly && <div className="mt-8 border-t pt-5"><button disabled={form.processing} className="pv-button">{form.processing ? 'Đang lưu…' : 'Lưu thay đổi'}</button></div>}
      </form>
    </section>
    {history && <section className="pv-panel mt-6 max-w-4xl overflow-hidden">
      <div className="flex flex-wrap items-center justify-between gap-4 border-b p-5"><div><h2 className="font-semibold">Lịch sử giao dịch</h2><p className="mt-1 text-sm text-muted-foreground">{history.count} chứng từ · Đã giao dịch {money(history.total)} · Còn nợ {money(history.balance)}</p></div><Link href={`/manage/${history.resource}?partner_id=${record.id}`} className="text-sm text-primary">Xem tất cả</Link></div>
      <div className="overflow-x-auto"><table className="pv-table"><thead><tr><th>Chứng từ</th><th>Ngày</th><th>Trạng thái</th><th className="text-right">Thành tiền</th><th className="text-right">Đã trả</th></tr></thead><tbody>{history.documents.map(document => <tr key={document.id}><td><Link className="text-primary" href={`/manage/${history.resource}/${document.id}`}>{document.code}</Link></td><td>{document.date}</td><td>{statusLabel(document.status)}</td><td className="text-right">{money(document.final_price)}</td><td className="text-right">{money(document.paid)}</td></tr>)}</tbody></table>{!history.documents.length && <p className="pv-empty">Đối tác chưa có giao dịch.</p>}</div>
    </section>}
  </>
}
function recordValue(value: string | number | boolean | null | File[] | undefined) { return Array.isArray(value) ? '' : value }
