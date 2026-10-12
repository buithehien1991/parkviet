import { Link, router, useForm, usePage } from '@inertiajs/react'
import { useEffect, useState } from 'react'
import { Minus, Plus, Search, ShoppingBasket, Trash2, X } from 'lucide-react'
import { money, type Product, type WorkspaceProps } from '@/types/business'
import { Errors, PageHeader } from '@/components/shared/business-form'

type CartLine = { product_id: number; quantity: number }
type Cart = {
  id: string; lines: CartLine[]; customer_id: string; discount: string; given: string;
  payment_method: string; partial: boolean; paid: string; note: string
}
type Customer = { id: number; name: string; phone?: string }
type Props = { products: Product[]; customers: Customer[]; can_create_customer: boolean }
const newCart = (): Cart => ({ id: crypto.randomUUID(), lines: [], customer_id: '', discount: '0', given: '', payment_method: 'cash', partial: false, paid: '0', note: '' })

function readCarts(key: string): Cart[] {
  try {
    const saved: unknown = JSON.parse(sessionStorage.getItem(key) || 'null')
    if (Array.isArray(saved) && saved.length && saved.every(isCart)) {
      return saved.map(cart => ({
        ...newCart(), ...cart,
        partial: cart.partial === true,
        paid: typeof cart.paid === 'string' ? cart.paid : '0',
        note: typeof cart.note === 'string' ? cart.note : '',
      }))
    }
  } catch { /* A restricted browser or invalid saved cart must not block sales. */ }
  return [newCart()]
}
function saveCarts(key: string, carts: Cart[]) {
  try { sessionStorage.setItem(key, JSON.stringify(carts)) } catch { /* Cart continues in memory when browser storage is unavailable. */ }
}
function isCart(value: unknown): value is Cart {
  if (!value || typeof value !== 'object') return false
  const cart = value as Partial<Cart>
  return typeof cart.id === 'string' && typeof cart.customer_id === 'string' &&
    typeof cart.discount === 'string' && typeof cart.given === 'string' &&
    ['cash', 'transfer', 'card'].includes(cart.payment_method || '') &&
    Array.isArray(cart.lines) && cart.lines.every(line => line && Number.isInteger(line.product_id) && Number.isFinite(line.quantity) && line.quantity > 0)
}

export default function Sale(props: Props) {
  const { props: shared } = usePage<WorkspaceProps>()
  const storageKey = `parkviet-carts-${shared.auth?.user?.id}-${shared.store?.id}`
  return <SaleWorkspace key={storageKey} {...props} storageKey={storageKey} />
}

function SaleWorkspace({ products, customers, storageKey, can_create_customer }: Props & { storageKey: string }) {
  const { props } = usePage<{ errors?: Record<string, string> }>()
  const [carts, setCarts] = useState<Cart[]>(() => readCarts(storageKey))
  const [active, setActive] = useState(0)
  const [search, setSearch] = useState('')
  const [cartError, setCartError] = useState('')
  const form = useForm({})
  useEffect(() => { saveCarts(storageKey, carts) }, [carts, storageKey])
  const cart = carts[active] || carts[0]
  const cartLines = cart.lines.flatMap(line => {
    const product = products.find(item => item.id === line.product_id)
    return product ? [{ ...line, product }] : []
  })
  const subtotal = cartLines.reduce((sum, line) => sum + Math.round(Number(line.product.sale_price) * line.quantity * 100) / 100, 0)
  const total = Math.round((subtotal - Number(cart.discount)) * 100) / 100
  const paid = cart.partial ? Number(cart.paid) : total
  const given = cart.payment_method === 'cash' ? Number(cart.given || 0) : paid
  const balance = total - paid
  const valid = cartLines.length > 0 && cartLines.length === cart.lines.length &&
    [total, paid, given, Number(cart.discount)].every(Number.isFinite) && total >= 0 &&
    Number(cart.discount) >= 0 && paid >= 0 && paid <= total && given >= paid &&
    (balance <= 0 || Boolean(cart.customer_id)) && cartLines.every(line => line.quantity <= Number(line.product.in_stock))
  const matches = products.filter(product => `${product.name} ${product.code}`.toLocaleLowerCase('vi').includes(search.toLocaleLowerCase('vi')))

  function update(values: Partial<Cart>) {
    setCarts(previous => previous.map(item => item.id === cart.id ? { ...item, ...values } : item))
  }
  function changeQuantity(product: Product, value: number, relative = false) {
    if (!Number.isFinite(value)) return
    setCartError('')
    setCarts(previous => previous.map(item => {
      if (item.id !== cart.id) return item
      const existing = item.lines.find(line => line.product_id === product.id)
      const quantity = relative ? (existing?.quantity || 0) + value : value
      if (quantity > Number(product.in_stock)) return item
      const lines = item.lines.filter(line => line.product_id !== product.id)
      if (quantity > 0) lines.push({ product_id: product.id, quantity: Math.round(quantity * 1000) / 1000 })
      return { ...item, lines }
    }))
  }
  function addProduct(product: Product) {
    const current = cart.lines.find(line => line.product_id === product.id)?.quantity || 0
    if (current >= Number(product.in_stock)) {
      setCartError(`${product.name}: đã đạt số lượng tồn kho hiện tại.`)
      return
    }
    const added = Math.min(1, Number(product.in_stock) - current)
    changeQuantity(product, added, true)
  }
  function closeCart(index: number) {
    if (carts[index].lines.length && !window.confirm('Bỏ giỏ hàng chưa thanh toán này?')) return
    const remaining = carts.filter((_, position) => position !== index)
    setCarts(remaining.length ? remaining : [newCart()])
    setActive(0)
    setCartError('')
  }
  function checkout() {
    if (!valid || form.processing) return
    form.transform(() => ({ source: 'sale', document: {
      request_key: cart.id, customer_id: cart.customer_id || null, discount_money: cart.discount,
      paid: paid.toFixed(2), given_money: given.toFixed(2), payment_method: cart.payment_method, note: cart.note,
      lines: cartLines.map(line => ({ product_id: line.product_id, quantity: line.quantity, unit_price: line.product.sale_price, discount_money: '0' }))
    }, finalize: true }))
    form.post('/manage/invoices', { onSuccess: () => {
      const remaining = carts.filter(item => item.id !== cart.id)
      const next = remaining.length ? remaining : [newCart()]
      saveCarts(storageKey, next)
      setCarts(next)
      setActive(0)
    } })
  }

  return <>
    <PageHeader title="Bán hàng" subtitle="Chọn sản phẩm. Kiểm tra giỏ hàng. Hoàn tất thanh toán.">
      {can_create_customer && <Link href="/manage/customers/new" className="pv-button-secondary">Thêm khách hàng</Link>}
      <button className="pv-button-secondary" onClick={() => router.reload({ only: ['products', 'customers'] })}>Cập nhật hàng & khách</button>
    </PageHeader>
    <Errors errors={{ ...props.errors, ...(cartError ? { cart: cartError } : {}) }} />
    <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_400px]">
      <section>
        <label className="relative mb-5 block"><Search size={18} className="absolute left-4 top-3.5 text-muted-foreground" />
          <input className="pv-input pl-11" placeholder="Tên sản phẩm hoặc mã vạch…" aria-label="Tìm sản phẩm bán" value={search} onChange={event => setSearch(event.target.value)} onKeyDown={event => {
            if (event.key !== 'Enter') return
            event.preventDefault()
            const exact = products.find(product => product.code.toLowerCase() === search.trim().toLowerCase())
            const product = exact || (matches.length === 1 ? matches[0] : undefined)
            if (product) { addProduct(product); setSearch('') }
          }} />
        </label>
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 2xl:grid-cols-4">{matches.map(product => <button key={product.id} className="pv-panel flex min-h-40 flex-col p-4 text-left transition-colors hover:border-primary disabled:opacity-50" disabled={Number(product.in_stock) <= 0} aria-label={`Thêm ${product.name} vào giỏ`} onClick={() => addProduct(product)}>
          <span className="mb-3 text-xs text-muted-foreground">{product.code}</span><span className="font-medium leading-snug">{product.name}</span><span className="mt-auto pt-4 font-semibold text-primary tabular-nums">{money(product.sale_price)}</span><span className="mt-1 text-xs text-muted-foreground">Tồn {product.in_stock} {product.basic_unit}</span>
        </button>)}</div>
        {!matches.length && <p className="pv-empty">Không tìm thấy sản phẩm. Thêm sản phẩm trong mục quản lý.</p>}
      </section>
      <section className="pv-panel flex min-w-0 flex-col">
        <div className="flex flex-wrap gap-1 border-b p-3">{carts.map((item, index) => <div key={item.id} className="flex items-center rounded-md border">
          <button className={index === active ? 'pv-button' : 'pv-button-quiet'} onClick={() => { setActive(index); setCartError('') }}>Đơn {index + 1}</button>
          <button className="pv-button-quiet px-2" aria-label={`Đóng giỏ hàng ${index + 1}`} onClick={() => closeCart(index)}><X size={14} /></button>
        </div>)}<button aria-label="Thêm giỏ hàng" className="pv-button-quiet" onClick={() => { setCarts(previous => [...previous, newCart()]); setActive(carts.length) }}><Plus size={18} /></button></div>
        <div className="border-b p-4"><label htmlFor="sale-customer" className="pv-label">Khách hàng</label><select id="sale-customer" className="pv-input" value={cart.customer_id} onChange={event => update({ customer_id: event.target.value })}><option value="">Khách lẻ</option>{customers.map(customer => <option key={customer.id} value={customer.id}>{customer.name} {customer.phone}</option>)}</select></div>
        <div className="min-h-56 flex-1 divide-y">{cartLines.map(line => <div key={line.product_id} className="p-4">
          <div className="flex justify-between gap-3 text-sm"><strong>{line.product.name}</strong><span className="tabular-nums">{money(Number(line.product.sale_price) * line.quantity)}</span></div>
          <div className="mt-3 flex items-center justify-between"><div className="flex items-center gap-1 rounded-md border">
            <button className="pv-button-quiet" aria-label={`Giảm ${line.product.name}`} onClick={() => changeQuantity(line.product, -1, true)}><Minus size={14} /></button>
            <input className="w-20 border-0 bg-transparent text-center text-sm" type="number" aria-label={`Số lượng ${line.product.name}`} min="0" max={line.product.in_stock} step="0.001" value={line.quantity} onChange={event => changeQuantity(line.product, Number(event.target.value))} />
            <button className="pv-button-quiet" aria-label={`Tăng ${line.product.name}`} disabled={line.quantity + 1 > Number(line.product.in_stock)} onClick={() => changeQuantity(line.product, 1, true)}><Plus size={14} /></button>
          </div><button className="pv-button-quiet text-muted-foreground" aria-label={`Xóa ${line.product.name}`} onClick={() => changeQuantity(line.product, 0)}><Trash2 size={16} /></button></div>
          {line.quantity > Number(line.product.in_stock) && <p className="pv-error">Tồn kho hiện tại chỉ còn {line.product.in_stock}.</p>}
        </div>)}{!cartLines.length && <div className="pv-empty"><ShoppingBasket className="mx-auto mb-3" size={32} />Giỏ hàng đang trống.</div>}</div>
        <div className="space-y-4 border-t p-5">
          <div className="flex justify-between text-sm"><span>Tổng tiền hàng</span><span className="tabular-nums">{money(subtotal)}</span></div>
          <div className="flex items-center justify-between gap-5"><label htmlFor="sale-discount" className="text-sm">Giảm giá</label><input id="sale-discount" type="number" min="0" max={subtotal} className="pv-input w-36 text-right" value={cart.discount} onChange={event => update({ discount: event.target.value })} /></div>
          <div className="flex items-center justify-between border-t pt-4"><span className="font-semibold">Tổng thanh toán</span><strong className="text-2xl text-primary tabular-nums">{money(total)}</strong></div>
          <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={cart.partial} onChange={event => update({ partial: event.target.checked })} />Thanh toán một phần / ghi nợ</label>
          {cart.partial && <div><label htmlFor="sale-paid" className="pv-label">Thu ngay</label><input id="sale-paid" type="number" min="0" max={total} className="pv-input" value={cart.paid} onChange={event => update({ paid: event.target.value })} /><p className="mt-2 flex justify-between text-sm"><span>Còn nợ</span><strong>{money(balance)}</strong></p>{balance > 0 && !cart.customer_id && <p className="pv-error">Chọn khách hàng để ghi nhận công nợ.</p>}</div>}
          <div><label htmlFor="sale-method" className="pv-label">Phương thức</label><select id="sale-method" className="pv-input" value={cart.payment_method} onChange={event => update({ payment_method: event.target.value })}><option value="cash">Tiền mặt</option><option value="transfer">Chuyển khoản</option><option value="card">Thẻ</option></select></div>
          {cart.payment_method === 'cash' && <div><label htmlFor="sale-given" className="pv-label">Tiền khách đưa</label><div className="flex gap-2"><input id="sale-given" className="pv-input" type="number" min="0" value={cart.given} onChange={event => update({ given: event.target.value })} /><button className="pv-button-secondary whitespace-nowrap" onClick={() => update({ given: paid.toFixed(2) })}>Đủ tiền</button></div><p className="mt-2 flex justify-between text-sm text-muted-foreground"><span>Tiền thừa</span><span>{money(Math.max(given - paid, 0))}</span></p></div>}
          <div><label htmlFor="sale-note" className="pv-label">Ghi chú</label><textarea id="sale-note" className="pv-input" rows={2} value={cart.note} onChange={event => update({ note: event.target.value })} /></div>
          <button className="pv-button w-full" disabled={!valid || form.processing} onClick={checkout}>{form.processing ? 'Đang thanh toán…' : 'Thanh toán & tạo hóa đơn'}</button>
          <p className="text-center text-xs text-muted-foreground">Chỉ ghi nhận chuyển khoản / thẻ đã xác nhận bên ngoài.</p>
        </div>
      </section>
    </div>
  </>
}
