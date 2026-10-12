import { Link, useForm } from '@inertiajs/react'
import { Errors, FormField, PageHeader } from '@/components/shared/business-form'
import type { Option } from '@/types/business'

type Member = { id?: number; store_role_id?: number; branch_id?: number; active?: boolean }
type Props = { member: Member; user?: { name?: string; email?: string } | null; roles: Option[]; branches: Option[]; errors: Record<string, string>; editable_profile: boolean }
export default function TeamForm({ member, user, roles, branches, errors, editable_profile }: Props) {
  const form = useForm({ member: { store_role_id: String(member.store_role_id || ''), branch_id: String(member.branch_id || ''), active: member.active ?? true }, user: { name: user?.name || '', email: user?.email || '', password: '', password_confirmation: '' } })
  return <>
    <PageHeader title={member.id ? 'Thông tin & phân quyền nhân viên' : 'Thêm nhân viên'}><Link href="/manage/members" className="pv-button-secondary">Quay lại</Link></PageHeader>
    <form className="pv-panel max-w-3xl p-6" onSubmit={event => { event.preventDefault(); if (member.id) form.patch(`/manage/members/${member.id}`); else form.post('/manage/members') }}>
      <Errors errors={errors} />
      {member.id && !editable_profile && <p className="mb-6 rounded-md bg-muted p-4 text-sm">{user?.name} · {user?.email}<br />Tài khoản đang dùng chung hoặc có quyền hệ thống. Chỉ điều chỉnh quyền tại cửa hàng này; chủ tài khoản tự sửa thông tin đăng nhập.</p>}
      <div className="grid gap-5 sm:grid-cols-2">
        {editable_profile && (['name', 'email', 'password', 'password_confirmation'] as const).map(key => <FormField key={key} field={{ key, label: { name: 'Họ tên', email: 'Email', password: member.id ? 'Mật khẩu mới (để trống: giữ nguyên)' : 'Mật khẩu', password_confirmation: 'Xác nhận mật khẩu' }[key], type: key.includes('password') ? 'password' : 'text', required: !member.id || key === 'email' }} value={form.data.user[key]} onChange={value => form.setData('user', { ...form.data.user, [key]: value })} />)}
        <FormField field={{ key: 'role', label: 'Vai trò', type: 'select', required: true, options: roles.map(role => ({ value: String(role.id), label: role.name })) }} value={form.data.member.store_role_id} onChange={value => form.setData('member', { ...form.data.member, store_role_id: value })} />
        <FormField field={{ key: 'branch', label: 'Chi nhánh', type: 'select', options: branches.map(branch => ({ value: String(branch.id), label: branch.name })) }} value={form.data.member.branch_id} onChange={value => form.setData('member', { ...form.data.member, branch_id: value })} />
        <label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" checked={form.data.member.active} onChange={event => form.setData('member', { ...form.data.member, active: event.target.checked })} />Cho phép truy cập cửa hàng</label>
      </div>
      <button className="pv-button mt-6" disabled={form.processing}>{form.processing ? 'Đang lưu…' : 'Lưu nhân viên'}</button>
    </form>
  </>
}
