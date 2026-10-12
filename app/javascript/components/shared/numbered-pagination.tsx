import { Link } from '@inertiajs/react'

import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from '@/components/ui/pagination'
import type { PaginationData } from '@/types'

type NumberedPaginationProps = {
  pagination: PaginationData
  buildHref: (page: number) => string
  itemLabel?: string
  preserveScroll?: boolean
  preserveState?: boolean
}

export function NumberedPagination({
  pagination,
  buildHref,
  itemLabel = 'items',
  preserveScroll = true,
  preserveState = true,
}: NumberedPaginationProps) {
  if (pagination.pages <= 1) {
    return (
      <div className="border-t pt-4 text-sm text-muted-foreground">
        Showing {pagination.from ?? 0} to {pagination.to ?? 0} of {pagination.count} {itemLabel}
      </div>
    )
  }

  return (
    <div className="flex flex-col gap-3 border-t pt-4 text-sm text-muted-foreground lg:flex-row lg:items-center lg:justify-between">
      <p>
        Showing {pagination.from ?? 0} to {pagination.to ?? 0} of {pagination.count} {itemLabel}
      </p>

      <Pagination className="mx-0 w-auto justify-start lg:justify-end">
        <PaginationContent>
          <PaginationItem>
            {pagination.prev ? (
              <PaginationPrevious
                href={buildHref(pagination.prev)}
                render={<Link href={buildHref(pagination.prev)} preserveScroll={preserveScroll} preserveState={preserveState} />}
              />
            ) : (
              <PaginationPrevious render={<span aria-disabled="true" />} className="opacity-50" />
            )}
          </PaginationItem>

          {buildPageItems(pagination).map((item, index) => (
            <PaginationItem key={item.type === 'page' ? `${item.type}-${item.value}` : `${item.type}-${index}`}>
              {item.type === 'ellipsis' ? (
                <PaginationEllipsis />
              ) : (
                <PaginationLink
                  href={buildHref(item.value)}
                  isActive={item.value === pagination.page}
                  render={
                    <Link href={buildHref(item.value)} preserveScroll={preserveScroll} preserveState={preserveState} />
                  }
                >
                  {item.value}
                </PaginationLink>
              )}
            </PaginationItem>
          ))}

          <PaginationItem>
            {pagination.next ? (
              <PaginationNext
                href={buildHref(pagination.next)}
                render={<Link href={buildHref(pagination.next)} preserveScroll={preserveScroll} preserveState={preserveState} />}
              />
            ) : (
              <PaginationNext render={<span aria-disabled="true" />} className="opacity-50" />
            )}
          </PaginationItem>
        </PaginationContent>
      </Pagination>
    </div>
  )
}

function buildPageItems(pagination: PaginationData) {
  const pages = new Set<number>([1, pagination.page - 1, pagination.page, pagination.page + 1, pagination.pages])
  const sortedPages = [...pages].filter((page) => page >= 1 && page <= pagination.pages).sort((a, b) => a - b)
  const items: Array<{ type: 'page'; value: number } | { type: 'ellipsis' }> = []

  sortedPages.forEach((page, index) => {
    const previousPage = sortedPages[index - 1]

    if (previousPage && page - previousPage > 1) {
      items.push({ type: 'ellipsis' })
    }

    items.push({ type: 'page', value: page })
  })

  return items
}
