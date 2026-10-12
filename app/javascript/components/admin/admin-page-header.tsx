import type { ReactNode } from 'react'

type AdminPageHeaderProps = {
  title: string
  description?: string
  actions?: ReactNode
  eyebrow?: string
}

export function AdminPageHeader({ title, description, actions, eyebrow = 'Admin' }: AdminPageHeaderProps) {
  return (
    <div className="border-b border-border/70 px-4 py-5 sm:px-6">
      <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
        <div className="space-y-2">
          <p className="text-xs font-medium uppercase tracking-[0.16em] text-muted-foreground">{eyebrow}</p>
          <div className="space-y-1">
            <h1 className="text-2xl font-semibold tracking-tight text-foreground text-balance">{title}</h1>
            {description ? <p className="max-w-2xl text-sm leading-6 text-muted-foreground">{description}</p> : null}
          </div>
        </div>
        {actions ? <div className="flex flex-wrap items-center gap-2">{actions}</div> : null}
      </div>
    </div>
  )
}
