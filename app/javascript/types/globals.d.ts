import type { FlashData, SharedProps } from '@/types'

declare module '@inertiajs/core' {
  export interface InertiaConfig {
    sharedPageProps: SharedProps
    flashDataType: FlashData
    errorValueType: string[]
  }
}

declare global {
  namespace React {
    interface ComponentType<P = {}> {
      layout?: (page: React.ReactNode) => React.ReactNode
    }
  }
}
