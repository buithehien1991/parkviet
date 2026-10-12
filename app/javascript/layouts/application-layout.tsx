import { Head, usePage } from '@inertiajs/react'
import type { ReactNode } from 'react'

import type { SharedProps } from '@/types'

type ApplicationLayoutProps = {
  children: ReactNode
}

export function ApplicationLayout({ children }: ApplicationLayoutProps) {
  const { props } = usePage<SharedProps>()

  return (
    <>
      {props.page_title ? <Head title={props.page_title} /> : null}
      <div className="min-h-screen bg-background text-foreground">
        {children}
      </div>
    </>
  )
}
