import type { FormEvent } from 'react'

import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import type { AdminUserSearch, SelectOption } from '@/types'

type UsersWorkspaceToolbarProps = {
  search: AdminUserSearch
  roleOptions: SelectOption[]
  statusOptions: SelectOption[]
  hasFilters: boolean
  onSearchChange: (search: AdminUserSearch) => void
  onApply: () => void
  onClear: () => void
}

export function UsersWorkspaceToolbar({
  search,
  roleOptions,
  statusOptions,
  hasFilters,
  onSearchChange,
  onApply,
  onClear,
}: UsersWorkspaceToolbarProps) {
  function submitFilters(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    onApply()
  }

  return (
    <form className="grid gap-3 rounded-xl border bg-muted/30 p-3 lg:grid-cols-[minmax(220px,1fr)_180px_180px_auto]" onSubmit={submitFilters}>
      <Input
        aria-label="Search users"
        value={search.email_or_name_or_username_cont ?? ''}
        onChange={(event) => onSearchChange({ ...search, email_or_name_or_username_cont: event.target.value })}
        placeholder="Search email, name, or username"
      />

      <Select value={search.role_id_eq ?? ''} onValueChange={(value) => onSearchChange({ ...search, role_id_eq: value ?? undefined })}>
        <SelectTrigger aria-label="Filter by role" className="w-full">
          <SelectValue placeholder="All roles" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="">All roles</SelectItem>
          {roleOptions.map((option) => (
            <SelectItem key={option.value} value={option.value}>{option.label}</SelectItem>
          ))}
        </SelectContent>
      </Select>

      <Select value={search.status_eq ?? ''} onValueChange={(value) => onSearchChange({ ...search, status_eq: value ?? undefined })}>
        <SelectTrigger aria-label="Filter by status" className="w-full">
          <SelectValue placeholder="All statuses" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="">All statuses</SelectItem>
          {statusOptions.map((option) => (
            <SelectItem key={option.value} value={option.value}>{option.label}</SelectItem>
          ))}
        </SelectContent>
      </Select>

      <div className="flex gap-2">
        <Button type="submit" variant="outline" className="flex-1 lg:flex-none">Apply</Button>
        {hasFilters ? (
          <Button type="button" variant="ghost" className="flex-1 lg:flex-none" onClick={onClear}>
            Clear
          </Button>
        ) : null}
      </div>
    </form>
  )
}
