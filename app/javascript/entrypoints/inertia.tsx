import { createInertiaApp } from '@inertiajs/react'
import { router } from '@inertiajs/react'
import { ThemeProvider } from 'next-themes'
import { createRoot } from 'react-dom/client'
import { toast } from 'sonner'
import './application.css'
import { resolvePageLayout } from '@/lib/layout-resolver'
import { Toaster } from '@/components/ui/sonner'
import { TooltipProvider } from '@/components/ui/tooltip'
import type { InertiaPageComponent, SharedProps } from '@/types'

type PageModule = {
  default: InertiaPageComponent
}

const pages = import.meta.glob<PageModule>('../pages/**/*.tsx')

router.on('success', (event) => {
  const flash = (event.detail.page.props as SharedProps).flash

  if (flash?.notice) {
    toast.success(flash.notice)
  }

  if (flash?.alert) {
    toast.error(flash.alert)
  }
})

void createInertiaApp({
  pages: "../pages",

  strictMode: true,

  defaults: {
    form: {
      forceIndicesArrayFormatInFormData: false,
      withAllErrors: true,
    },
    visitOptions: () => {
      return { queryStringArrayFormat: "brackets" }
    },
  },
  resolve: async (name) => {
    const page = pages[`../pages/${name}.tsx`]

    if (page) {
      const component = (await page()).default
      component.layout ??= (pageNode) => resolvePageLayout(pageNode, component)

      return component
    }

    throw new Error(`Page not found: ${name}`)
  },
  setup({ el, App, props }) {
    if (!el) {
      throw new Error('Missing Inertia root element')
    }

    createRoot(el).render(
      <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
        <TooltipProvider>
          <App {...props} />
          <Toaster richColors />
        </TooltipProvider>
      </ThemeProvider>
    )
  },
}).catch((error) => {
  // This ensures this entrypoint is only loaded on Inertia pages
  // by checking for the presence of the root element (#app by default).
  // Feel free to remove this `catch` if you don't need it.
  if (document.getElementById("app")) {
    throw error
  } else {
    console.error(
      "Missing root element.\n\n" +
      "If you see this error, it probably means you loaded Inertia.js on non-Inertia pages.\n" +
      'Consider moving <%= vite_typescript_tag "inertia.tsx" %> to the Inertia-specific layout instead.',
    )
  }
})
