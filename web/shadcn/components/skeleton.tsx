import { cn } from '@shadcn/lib/utils'
import React, { useEffect, useState } from 'react'

interface BaseProps extends React.HTMLAttributes<HTMLDivElement> {
  className?: string
}

function Skeleton({ className, ...props }: BaseProps) {
  return <div className={cn('animate-pulse rounded-md bg-primary/10', className)} {...props} />
}

interface SkeletonTextProps extends BaseProps {
  lines?: number
}

function SkeletonText({ lines = 3, className, ...props }: SkeletonTextProps) {
  return (
    <div className={cn('space-y-2', className)} {...props}>
      {Array.from({ length: lines }).map((_, i) => (
        <div
          key={i}
          className={cn('h-3 rounded bg-primary/10', i === lines - 1 ? 'w-3/4' : 'w-full')}
        />
      ))}
    </div>
  )
}

interface SkeletonCircleProps extends BaseProps {
  size?: number | string
}

function SkeletonCircle({ size = 10, className, ...props }: SkeletonCircleProps) {
  const sizeClass = typeof size === 'number' ? `h-${size} w-${size}` : ''
  return (
    <div
      className={cn('rounded-full bg-primary/10 animate-pulse', sizeClass, className)}
      {...props}
    />
  )
}

interface SkeletonBlockProps extends BaseProps {
  height?: string
  width?: string
}

function SkeletonBlock({
  height = 'h-4',
  width = 'w-full',
  className,
  ...props
}: SkeletonBlockProps) {
  return (
    <div
      className={cn('rounded-md bg-primary/10 animate-pulse', height, width, className)}
      {...props}
    />
  )
}

interface SkeletonWrapperProps {
  isLoading: boolean
  children: React.ReactNode
  fallback?: React.ReactNode
  delay?: number // ms
  className?: string
}

function SkeletonWrapper({
  isLoading,
  children,
  fallback,
  delay = 0,
  className,
}: SkeletonWrapperProps) {
  const [showSkeleton, setShowSkeleton] = useState(isLoading && delay === 0)

  useEffect(() => {
    let t: number | undefined

    if (isLoading) {
      if (delay > 0) {
        setShowSkeleton(false)
        t = window.setTimeout(() => setShowSkeleton(true), delay)
      } else {
        setShowSkeleton(true)
      }
    } else {
      setShowSkeleton(false)
    }

    return () => {
      if (t) clearTimeout(t)
    }
  }, [isLoading, delay])

  if (isLoading && showSkeleton) {
    // Se o fallback for um elemento React, injeta className e animação
    if (fallback) {
      if (React.isValidElement(fallback)) {
        return React.cloneElement(fallback, {
          className: cn('animate-pulse', fallback.props.className, className),
        })
      }
      return <>{fallback}</>
    }
    return <Skeleton className={className} />
  }

  return <>{children}</>
}

export { Skeleton, SkeletonBlock, SkeletonCircle, SkeletonText, SkeletonWrapper }
