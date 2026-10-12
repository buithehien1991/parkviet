import { Head, usePage } from '@inertiajs/react'
import type { ReactNode } from 'react'

import { AdminShell } from '@/components/admin/admin-shell'
import type { SharedProps } from '@/types'

type AdminLayoutProps = {
  children: ReactNode
}

export function AdminLayout({ children }: AdminLayoutProps) {
  const { props } = usePage<SharedProps>()

  return (
    <>
      {props.page_title ? <Head title={props.page_title} /> : null}
      <AdminShell>{children}</AdminShell>
    </>
  )
}
