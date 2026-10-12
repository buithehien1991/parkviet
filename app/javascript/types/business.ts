export type FieldValue = string | number | boolean | null
export type BusinessRecord = { id?: number } & Record<string, FieldValue>
export type Field = { key: string; label: string; type: string; required?: boolean; options?: { value: string; label: string }[] }
export type Option = { id: number; name: string }
export type Product = Option & { code: string; sale_price: string; cost_price: string; in_stock: string; basic_unit: string }
export type Line = { product_id: string | number; product_name?: string; quantity: string; unit_price: string; discount_money: string; final_price?: string; unit?: string }
export type Document = {
  id?: number; name?: string; code?: string; date: string; status?: string; request_key: string;
  customer_id?: number | null; supplier_id?: number | null; purchase_order_id?: number | null;
  discount_money: string; paid: string; given_money: string; returned_money?: string;
  total_price?: string; final_price?: string; payment_method: string; note: string;
  partner_name?: string; lines: Line[]
}
export type WorkspaceProps = {
  store?: Option; stores?: Option[]; store_permissions?: string[];
  auth?: { user?: { id: number; name: string | null; email: string; role: string | null } | null }
}
export const money = (value: string | number | null | undefined) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(Number(value || 0))
export const statusLabel = (value?: string) => ({ created: 'Nháp', approved: 'Đã duyệt', completed: 'Hoàn thành', purchased: 'Đã nhập', canceled: 'Đã hủy', active: 'Hoạt động', inactive: 'Ngừng hoạt động', archived: 'Lưu trữ' }[value || ''] || value || '—')
