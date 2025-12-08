import Header from '@app/components/layout/Header'
import { Box } from '@shadcn/layout'
import { cn } from '@shadcn/lib/utils'
import * as React from 'react'
import { Outlet } from 'react-router-dom'

export interface MainLayoutProps {
  className?: string
}

export const MainLayout = React.forwardRef<HTMLDivElement, MainLayoutProps>(
  ({ className }, ref) => {
    return (
      <Box
        ref={ref}
        className={cn(
          'relative min-h-screen flex flex-col antialiased overflow-hidden',
          'bg-gradient-to-br from-midnight-800 via-midnight-800 to-lavanda-800',
          className
        )}
      >
        <div className="pointer-events-none absolute -top-32 -left-32 h-[520px] w-[520px] bg-midnight-700 opacity-40 blur-3xl rounded-full" />

        <Header />

        <Box as="main" className="relative z-10 flex-1 flex flex-col">
          <Outlet />
        </Box>
      </Box>
    )
  }
)

MainLayout.displayName = 'MainLayout'
