import { Link, router } from '@inertiajs/react'
import { PageHeader } from '@/components/shared/business-form'

export default function RoleIndex({ roles }: { roles: { id: number; name: string; permissions: string[] }[] }) {
  return <><PageHeader title="Vai trò & quyền" subtitle="Quyền nhân viên độc lập với quản trị hệ thống."><Link href="/manage/store_roles/new" className="pv-button">Tạo vai trò</Link></PageHeader><div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">{roles.map(role => <section key={role.id} className="pv-panel p-6"><h2 className="text-lg font-semibold">{role.name}</h2><p className="mt-2 text-sm text-muted-foreground">{role.permissions.length} quyền được cấp</p><div className="mt-5 flex gap-2"><Link href={`/manage/store_roles/${role.id}/edit`} className="pv-button-secondary">Sửa quyền</Link><button className="pv-button-quiet text-destructive" onClick={() => { if (window.confirm('Xóa vai trò? Vai trò đang có nhân viên sẽ không bị xóa.')) router.delete(`/manage/store_roles/${role.id}`) }}>Xóa</button></div></section>)}</div></>
}
