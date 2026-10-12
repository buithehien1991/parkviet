import { router, usePage } from '@inertiajs/react'
import { useEffect, useMemo, useState } from 'react'
import { PlusIcon, SearchIcon, UsersIcon } from 'lucide-react'

import {
  Command,
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
  CommandShortcut,
} from '@/components/ui/command'
import { Kbd } from '@/components/ui/kbd'
import { Button } from '@/components/ui/button'

type CommandAction = {
  group: string
  icon: React.ComponentType<{ className?: string }>
  label: string
  shortcut?: string
  when?: boolean
  run: () => void
}

export function AdminCommandMenu() {
  const page = usePage()
  const currentPath = page.url.split('?')[0]
  const [open, setOpen] = useState(false)

  useEffect(() => {
    function handleKeyDown(event: KeyboardEvent) {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === 'k') {
        event.preventDefault()
        setOpen((value) => !value)
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [])

  const actions = useMemo<CommandAction[]>(() => [
    {
      group: 'Navigation',
      icon: SearchIcon,
      label: 'Go to Dashboard',
      shortcut: 'G D',
      when: currentPath !== '/admin',
      run: () => router.visit('/admin'),
    },
    {
      group: 'Navigation',
      icon: UsersIcon,
      label: 'Go to Users',
      shortcut: 'G U',
      when: currentPath !== '/admin/users',
      run: () => router.visit('/admin/users'),
    },
    {
      group: 'Actions',
      icon: PlusIcon,
      label: 'Create User',
      shortcut: 'N U',
      run: () => router.visit('/admin/users/new'),
    },
  ], [currentPath])

  const groups = actions.filter((action) => action.when !== false).reduce<Record<string, CommandAction[]>>((collection, action) => {
    collection[action.group] ||= []
    collection[action.group].push(action)
    return collection
  }, {})

  return (
    <>
      <Button
        type="button"
        variant="outline"
        aria-haspopup="dialog"
        aria-expanded={open}
        className="h-9 w-full cursor-pointer justify-between gap-3 rounded-xl border-border/70 bg-background/70 px-3 text-muted-foreground shadow-none hover:bg-muted/60 sm:w-[280px]"
        onClick={() => setOpen(true)}
      >
        <span className="flex min-w-0 items-center gap-2">
          <SearchIcon className="size-4" aria-hidden="true" />
          <span className="truncate">Search Pages & Actions…</span>
        </span>
        <Kbd>⌘K</Kbd>
      </Button>

      <CommandDialog open={open} onOpenChange={setOpen}>
        <Command>
          <CommandInput aria-label="Search pages and admin actions" placeholder="Search pages and admin actions…" />
          <CommandList>
            <CommandEmpty>No matching actions.</CommandEmpty>
            {Object.entries(groups).map(([group, items], index) => (
              <div key={group}>
                {index > 0 ? <CommandSeparator /> : null}
                <CommandGroup heading={group}>
                  {items.map((item) => (
                    <CommandItem
                      key={item.label}
                      value={item.label}
                      onSelect={() => {
                        setOpen(false)
                        item.run()
                      }}
                    >
                      <item.icon className="size-4" aria-hidden="true" />
                      <span>{item.label}</span>
                      {item.shortcut ? <CommandShortcut>{item.shortcut}</CommandShortcut> : null}
                    </CommandItem>
                  ))}
                </CommandGroup>
              </div>
            ))}
          </CommandList>
        </Command>
      </CommandDialog>
    </>
  )
}
