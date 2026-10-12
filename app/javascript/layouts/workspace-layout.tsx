import { Head, Link, router, usePage } from '@inertiajs/react'
import { useState, type ReactNode } from 'react'
import { Banknote, Boxes, ChartNoAxesCombined, ChevronDown, CircleUserRound, ClipboardList, FileText, LayoutDashboard, LogOut, Menu, Package, Receipt, Settings, ShoppingCart, Store, Truck, Users, X } from 'lucide-react'
import type { WorkspaceProps } from '@/types/business'

const navigation = [
  { label: 'Tổng quan', href: '/manage', icon: LayoutDashboard },
  { label: 'Bán hàng', href: '/sale', icon: ShoppingCart, permission: 'invoice_new' },
  { label: 'Sản phẩm', href: '/manage/products', icon: Package, permission: 'product_view' },
  { label: 'Hóa đơn', href: '/manage/invoices', icon: Receipt, permission: 'invoice_view' },
  { label: 'Nhập hàng', href: '/manage/purchases', icon: Truck, permission: 'purchase_view' },
  { label: 'Đặt nhập hàng', href: '/manage/purchase_orders', icon: ClipboardList, permission: 'purchase_order_view' },
  { label: 'Khách hàng', href: '/manage/customers', icon: Users, permission: 'customer_view' },
  { label: 'Nhà cung cấp', href: '/manage/suppliers', icon: Store, permission: 'supplier_view' },
  { label: 'Nhân viên', href: '/manage/members', icon: CircleUserRound, permission: 'user_view' },
  { label: 'Công nợ', href: '/manage/debts', icon: Banknote, permissions: ['invoice_view', 'purchase_view'] },
  { label: 'Ghi nhận', href: '/manage/reports', icon: ChartNoAxesCombined, permission: 'report_view' },
]

export function WorkspaceLayout({ children }: { children: ReactNode }) {
  const { props, url } = usePage<WorkspaceProps>()
  const [open, setOpen] = useState(false)
  const permissions = props.store_permissions || []
  return <>
    <Head title="Park Việt" />
    {open && <button aria-label="Đóng menu" className="fixed inset-0 z-30 bg-foreground/30 lg:hidden" onClick={() => setOpen(false)} />}
    <aside className={`pv-sidebar fixed inset-y-0 left-0 z-40 flex w-60 flex-col border-r bg-card transition-transform lg:translate-x-0 ${open ? 'translate-x-0' : '-translate-x-full'}`}>
      <Link href="/manage" className="flex h-20 items-center gap-3 px-6 text-lg font-semibold tracking-tight"><span className="flex size-9 items-center justify-center rounded-lg bg-primary text-primary-foreground"><Boxes size={21} /></span>Park Việt<span className="text-primary">.</span></Link>
      <button className="absolute right-3 top-6 lg:hidden" aria-label="Đóng menu" onClick={() => setOpen(false)}><X size={20} /></button>
      <div className="mx-4 mb-6 rounded-lg border bg-muted/40 p-3"><label htmlFor="store-switch" className="mb-1 block text-xs text-muted-foreground">CỬA HÀNG ĐANG LÀM VIỆC</label><div className="flex items-center gap-2"><select id="store-switch" className="w-full min-w-0 bg-transparent text-sm font-medium" value={props.store?.id || ''} onChange={event => router.post(`/stores/${event.target.value}/switch`)}>{props.stores?.map(store => <option key={store.id} value={store.id}>{store.name}</option>)}</select><ChevronDown size={14} /></div></div>
      <nav aria-label="Điều hướng chính" className="flex-1 space-y-1 overflow-y-auto px-3">
        {navigation.filter(item => item.permissions ? item.permissions.some(permission => permissions.includes(permission)) : !item.permission || permissions.includes(item.permission)).map(item => {
          const active = item.href === '/manage' ? url === '/manage' : url.startsWith(item.href)
          return <Link key={item.href} href={item.href} onClick={() => setOpen(false)} className={`flex min-h-11 items-center gap-3 rounded-lg px-3 text-sm transition-colors ${active ? 'bg-primary/10 font-semibold text-primary' : 'text-muted-foreground hover:bg-muted hover:text-foreground'}`}><item.icon size={18} />{item.label}</Link>
        })}
        {permissions.includes('system_setting') && <div className="mt-5 border-t pt-4"><p className="mb-2 px-3 text-xs font-medium text-muted-foreground">THIẾT LẬP</p>{[['/manage/store_settings/edit', 'Thông tin cửa hàng'], ['/manage/product_groups', 'Nhóm sản phẩm'], ['/manage/producers', 'Nhà sản xuất'], ['/manage/product_types', 'Loại sản phẩm'], ['/manage/branches', 'Chi nhánh'], ['/manage/store_roles', 'Vai trò & quyền'], ['/manage/print_templates', 'Mẫu in']].map(([href, label]) => <Link key={href} href={href} className="flex min-h-11 items-center gap-3 rounded-lg px-3 text-sm text-muted-foreground hover:bg-muted"><Settings size={16} />{label}</Link>)}</div>}
      </nav>
      <div className="m-3 border-t pt-3"><p className="truncate px-3 text-sm font-medium">{props.auth?.user?.name || props.auth?.user?.email}</p><div className="mt-2 flex justify-between"><Link href="/users/edit" className="pv-button-quiet"><FileText size={16} />Tài khoản</Link><Link href="/users/sign_out" method="delete" as="button" className="pv-button-quiet" aria-label="Đăng xuất"><LogOut size={16} /></Link></div></div>
    </aside>
    <div className="pv-workspace min-h-screen lg:pl-60"><div className="pv-topbar flex h-16 items-center justify-between border-b bg-card px-4 sm:px-8"><div className="flex items-center gap-3"><button className="pv-button-quiet lg:hidden" aria-label="Mở menu" onClick={() => setOpen(true)}><Menu size={22} /></button><p className="text-sm text-muted-foreground">Không gian quản lý <span className="ml-2 text-foreground">/ {props.store?.name}</span></p></div><span className="hidden text-xs text-muted-foreground sm:block">Quản lý rõ ràng. Bán hàng nhẹ nhàng.</span></div><main className="mx-auto max-w-screen-2xl p-4 sm:p-8">{children}</main></div>
  </>
}
