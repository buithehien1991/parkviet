import type { ReactNode } from 'react'

import { ScrollArea } from '@/components/ui/scroll-area'
import { Separator } from '@/components/ui/separator'

type ContentSectionProps = {
  title: string
  description?: string
  children: ReactNode
}

export function ContentSection({ title, description, children }: ContentSectionProps) {
  return (
    <div className="flex flex-1 flex-col">
      <div className="flex-none">
        <h3 className="text-lg font-medium">{title}</h3>
        {description ? (
          <p className="text-sm text-muted-foreground">{description}</p>
        ) : null}
      </div>
      <Separator className="my-4 flex-none" />
      <ScrollArea className="-mx-1 flex-1 px-1 lg:max-h-[calc(100svh-22rem)] faded-bottom">
        <div className="px-1 pb-12 lg:px-1.5">{children}</div>
      </ScrollArea>
    </div>
  )
}
