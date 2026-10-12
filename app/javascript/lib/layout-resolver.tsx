import { usePage } from '@inertiajs/react'
import type { ReactNode } from 'react'

import { AdminLayout } from '@/layouts/admin-layout'
import { ApplicationLayout } from '@/layouts/application-layout'
import { FullscreenLayout } from '@/layouts/fullscreen-layout'
import { WorkspaceLayout } from '@/layouts/workspace-layout'
import type { InertiaPageComponent, ReactLayoutName, SharedProps } from '@/types'

const layouts: Record<ReactLayoutName, ({ children }: { children: ReactNode }) => ReactNode> = {
  application: ApplicationLayout,
  admin: AdminLayout,
  fullscreen: FullscreenLayout,
  workspace: WorkspaceLayout,
}

function LayoutResolver({ children }: { children: ReactNode }) {
  const { props } = usePage<SharedProps>()
  const layoutName = props.react_layout || 'application'
  const Layout = layouts[layoutName] ?? ApplicationLayout

  return <Layout>{children}</Layout>
}

export function resolvePageLayout(page: ReactNode, _component: InertiaPageComponent) {
  return <LayoutResolver>{page}</LayoutResolver>
}
