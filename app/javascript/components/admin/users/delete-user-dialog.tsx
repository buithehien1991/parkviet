import { router } from '@inertiajs/react'
import { TriangleAlert } from 'lucide-react'

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogMedia,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog'
import type { AdminUserSearch } from '@/types'

type DeleteUserDialogProps = {
  open: boolean
  onOpenChange: (open: boolean) => void
  userId: number | null
  userLabel: string
  filters?: AdminUserSearch
}

export function DeleteUserDialog({
  open,
  onOpenChange,
  userId,
  userLabel,
  filters = {},
}: DeleteUserDialogProps) {
  function destroyUser() {
    if (!userId) {
      return
    }

    router.delete(`/admin/users/${userId}`, {
      data: { q: filters },
      preserveScroll: true,
      onSuccess: () => onOpenChange(false),
    })
  }

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogMedia>
            <TriangleAlert className="text-destructive" />
          </AlertDialogMedia>
          <AlertDialogTitle>Delete user</AlertDialogTitle>
          <AlertDialogDescription>
            Delete <span className="font-medium text-foreground">{userLabel}</span>? This action cannot be undone.
          </AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel>Cancel</AlertDialogCancel>
          <AlertDialogAction variant="destructive" onClick={destroyUser}>
            Delete user
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
