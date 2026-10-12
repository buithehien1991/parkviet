import type { ChangeEvent, ReactNode } from 'react'
import type { Field, FieldValue } from '@/types/business'

export function FormField({ field, value, onChange, error, disabled = false }: { field: Field; value: FieldValue | undefined; onChange: (value: string) => void; error?: string; disabled?: boolean }) {
  const id = `field-${field.key}`
  const common = { id, disabled, required: field.required, 'aria-invalid': Boolean(error), 'aria-describedby': error ? `${id}-error` : undefined, className: 'pv-input', value: String(value ?? ''), onChange: (event: ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => onChange(event.target.value) }
  return <div className={field.type === 'textarea' ? 'sm:col-span-2' : ''}>
    <label className="pv-label" htmlFor={id}>{field.label}{field.required ? ' *' : ''}</label>
    {field.type === 'select' && <select {...common}><option value="">Chọn…</option>{field.options?.map(option => <option key={option.value} value={option.value}>{option.label}</option>)}</select>}
    {field.type === 'textarea' && <textarea {...common} rows={4} />}
    {!['select', 'textarea'].includes(field.type) && <input {...common} type={field.type} min={field.type === 'number' ? '0' : undefined} step={field.type === 'number' ? 'any' : undefined} />}
    {error ? <p className="pv-error" id={`${id}-error`}>{error}</p> : null}
  </div>
}

export function Errors({ errors }: { errors: Record<string, string> }) {
  return Object.keys(errors).length ? <div role="alert" className="mb-6 rounded-lg border border-destructive/30 bg-destructive/5 p-4 text-sm text-destructive">{Object.entries(errors).map(([key, error]) => <p key={key}>{error}</p>)}</div> : null
}

export function PageHeader({ title, subtitle, children }: { title: string; subtitle?: string; children?: ReactNode }) {
  return <header className="mb-6 flex flex-wrap items-center justify-between gap-4"><div><h1 className="text-2xl font-semibold tracking-tight">{title}</h1>{subtitle ? <p className="mt-1 text-sm text-muted-foreground">{subtitle}</p> : null}</div><div className="flex flex-wrap gap-2">{children}</div></header>
}
