import Header from '@app/components/layout/Header'
import Particles from '@app/components/Particles/Stars/Particles'
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
          'bg-gradient-to-br from-navy-600 via-navy-800 to-navy-900',
          className
        )}
      >
        <div className="pointer-events-none absolute -top-32 -left-32 h-[420px] w-[420px] bg-navy-500 opacity-30 blur-3xl rounded-full" />

        {/* <AsteroidsBackground /> */}
        <Particles
          particleCount={1720}
          particleSpread={12}
          speed={0.13}
          particleBaseSize={50.5}
          sizeRandomness={2}
          particleColors={['#ffffff', '#c7d2fe']}
          alphaParticles={true}
          disableRotation={true}
          moveParticlesOnHover={false}
          pixelRatio={Math.min(window.devicePixelRatio, 2)}
          className="w-full h-full absolute top-0 left-0"
        />
        <Header />

        <Box as="main" className="relative z-10 flex-1 flex flex-col">
          <Outlet />
        </Box>
      </Box>
    )
  }
)

MainLayout.displayName = 'MainLayout'
