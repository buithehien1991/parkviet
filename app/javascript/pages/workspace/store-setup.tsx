import { Head, useForm } from '@inertiajs/react'
import { Store } from 'lucide-react'
import { Errors, FormField } from '@/components/shared/business-form'

export default function StoreSetup({ errors = {} }: { errors?: Record<string, string> }) {
  const form = useForm({ store: { name: '', phone: '', address: '', tax: '' } })
  return <><Head title="Tạo cửa hàng" /><main className="mx-auto max-w-xl px-6 py-16"><Store className="mb-6 text-primary" size={40} /><h1 className="text-3xl font-semibold tracking-tight">Bắt đầu với cửa hàng của bạn</h1><p className="mb-8 mt-3 text-muted-foreground">Một không gian riêng cho sản phẩm, chứng từ và đội ngũ.</p><Errors errors={errors} /><form className="space-y-5" onSubmit={event => { event.preventDefault(); form.post('/stores') }}>{[{ key: 'name', label: 'Tên cửa hàng', required: true }, { key: 'phone', label: 'Điện thoại' }, { key: 'address', label: 'Địa chỉ' }, { key: 'tax', label: 'Mã số thuế' }].map(field => <FormField key={field.key} field={{ ...field, type: 'text' }} value={form.data.store[field.key as keyof typeof form.data.store]} onChange={value => form.setData('store', { ...form.data.store, [field.key]: value })} />)}<button className="pv-button" disabled={form.processing}>Tạo cửa hàng</button></form></main></>
}
