import { Button } from '@/components/ui/button'
import type { PaginationData } from '@/types'

type PaginationControlsProps = {
  pagination: PaginationData
  itemLabel?: string
  onPageChange: (page: number | null) => void
}

export function PaginationControls({
  pagination,
  itemLabel = 'items',
  onPageChange,
}: PaginationControlsProps) {
  return (
    <div className="flex flex-col gap-3 border-t pt-4 text-sm text-muted-foreground sm:flex-row sm:items-center sm:justify-between">
      <p>
        Showing {pagination.from ?? 0} to {pagination.to ?? 0} of {pagination.count} {itemLabel}
      </p>

      <div className="flex gap-2">
        <Button
          variant="outline"
          size="sm"
          disabled={!pagination.prev}
          onClick={() => onPageChange(pagination.prev)}
        >
          Previous
        </Button>
        <Button
          variant="outline"
          size="sm"
          disabled={!pagination.next}
          onClick={() => onPageChange(pagination.next)}
        >
          Next
        </Button>
      </div>
    </div>
  )
}
