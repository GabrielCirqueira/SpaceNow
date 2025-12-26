import { cn } from '@shadcn/lib/utils'
import * as React from 'react'

export interface ImageProps extends React.ImgHTMLAttributes<HTMLImageElement> {
  as?: 'img'
  objectFit?: 'contain' | 'cover' | 'fill' | 'none' | 'scale-down'
  rounded?: boolean
  roundedSize?: 'sm' | 'md' | 'lg' | 'full'
}

export const Image = React.forwardRef<HTMLImageElement, ImageProps>(
  ({ className, objectFit = 'cover', rounded = false, roundedSize = 'md', ...props }, ref) => {
    const objectFitClass = {
      contain: 'object-contain',
      cover: 'object-cover',
      fill: 'object-fill',
      none: 'object-none',
      'scale-down': 'object-scale-down',
    }[objectFit]

    const roundedClass = rounded
      ? {
          sm: 'rounded-sm',
          md: 'rounded-md',
          lg: 'rounded-lg',
          full: 'rounded-full',
        }[roundedSize]
      : ''

    return (
      <img
        ref={ref}
        className={cn('max-w-full h-auto', objectFitClass, roundedClass, className)}
        {...props}
      />
    )
  }
)

Image.displayName = 'Image'

export default Image
