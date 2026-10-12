import { router, usePage } from '@inertiajs/react'
import { LogOutIcon, SettingsIcon, ShieldCheckIcon } from 'lucide-react'

import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import type { SharedProps } from '@/types'

function userInitials(name?: string | null, email?: string | null) {
  const source = name?.trim() || email?.trim() || 'A'
  const words = source.split(/\s+/).filter(Boolean)

  if (words.length === 1) {
    return words[0].slice(0, 2).toUpperCase()
  }

  return words.slice(0, 2).map((word) => word[0]).join('').toUpperCase()
}

export function AdminAccountMenu() {
  const page = usePage<SharedProps>()
  const user = page.props.auth?.user

  if (!user) {
    return null
  }

  const displayName = user.name || user.username || user.email
  const roleLabel = user.role || 'admin'

  return (
    <DropdownMenu>
      <DropdownMenuTrigger
        render={
          <Button
            type="button"
            variant="ghost"
            className="h-10 items-center gap-3 rounded-xl px-2 hover:bg-muted/80"
          />
        }
      >
        <Avatar size="sm">
          <AvatarFallback>{userInitials(user.name, user.email)}</AvatarFallback>
        </Avatar>
        <span className="hidden min-w-0 text-left sm:block">
          <span className="block truncate text-sm font-medium text-foreground">{displayName}</span>
          <span className="block truncate text-xs text-muted-foreground">{roleLabel}</span>
        </span>
      </DropdownMenuTrigger>

      <DropdownMenuContent align="end" className="w-64">
        <DropdownMenuGroup>
          <DropdownMenuLabel className="px-2 py-2">
            <div className="space-y-1">
              <p className="truncate text-sm font-medium text-foreground">{displayName}</p>
              <p className="truncate text-xs font-normal text-muted-foreground">{user.email}</p>
            </div>
          </DropdownMenuLabel>
        </DropdownMenuGroup>
        <DropdownMenuSeparator />
        <DropdownMenuItem onClick={() => router.visit('/users/edit')}>
          <SettingsIcon className="size-4" aria-hidden="true" />
          Account Settings
        </DropdownMenuItem>
        <DropdownMenuItem disabled>
          <ShieldCheckIcon className="size-4" aria-hidden="true" />
          Signed In As {roleLabel}
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          variant="destructive"
          onClick={() => router.delete('/users/sign_out')}
        >
          <LogOutIcon className="size-4" aria-hidden="true" />
          Sign Out
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
