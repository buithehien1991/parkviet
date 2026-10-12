import { Head, usePage } from '@inertiajs/react'
import type { ReactNode } from 'react'

import type { SharedProps } from '@/types'

type FullscreenLayoutProps = {
  children: ReactNode
}

export function FullscreenLayout({ children }: FullscreenLayoutProps) {
  const { props } = usePage<SharedProps>()

  return (
    <>
      {props.page_title ? <Head title={props.page_title} /> : null}
      <div className="min-h-screen bg-muted/30 text-foreground">
        {children}
      </div>
    </>
  )
}
