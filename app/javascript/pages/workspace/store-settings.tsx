import { Link, useForm } from '@inertiajs/react'
import { Errors, FormField, PageHeader } from '@/components/shared/business-form'

export default function StoreSettings({ details, errors }: { details: { name: string; phone: string | null; address: string | null; tax: string | null; description: string | null }; errors: Record<string, string> }) {
  const form = useForm({ store: { name: details.name, phone: details.phone || '', address: details.address || '', tax: details.tax || '', description: details.description || '' } })
  const fields = [
    { key: 'name', label: 'Tên cửa hàng', type: 'text', required: true },
    { key: 'phone', label: 'Điện thoại', type: 'tel' },
    { key: 'address', label: 'Địa chỉ', type: 'text' },
    { key: 'tax', label: 'Mã số thuế', type: 'text' },
    { key: 'description', label: 'Giới thiệu / ghi chú', type: 'textarea' },
  ]
  return <>
    <PageHeader title="Thông tin cửa hàng" subtitle="Thông tin này được dùng trên các hóa đơn và phiếu nhập.">
      <Link href="/manage/print_templates" className="pv-button-secondary">Thiết lập mẫu in</Link>
      <Link href="/stores/new" className="pv-button-secondary">Tạo cửa hàng khác</Link>
    </PageHeader>
    <form className="pv-panel max-w-3xl p-6" onSubmit={event => { event.preventDefault(); form.patch('/manage/store_settings') }}>
      <Errors errors={errors} />
      <div className="grid gap-5 sm:grid-cols-2">{fields.map(field => <FormField key={field.key} field={field} value={form.data.store[field.key as keyof typeof form.data.store]} error={errors[field.key]} onChange={value => form.setData('store', { ...form.data.store, [field.key]: value })} />)}</div>
      <button className="pv-button mt-6" disabled={form.processing}>{form.processing ? 'Đang lưu…' : 'Lưu thông tin'}</button>
    </form>
  </>
}
