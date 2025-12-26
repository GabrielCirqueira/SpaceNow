import { Icon } from '@app/shadcn/components'
import { Moon, Orbit, Rocket, Satellite, Sparkles, Star } from 'lucide-react'
import { useMemo } from 'react'

export const spaceIcons = [Rocket, Star, Orbit, Satellite, Moon, Sparkles]

export function FloatingIconsBackground() {
  const icons = useMemo(() => {
    return Array.from({ length: 20 }).map((_, i) => {
      const IconSpace = spaceIcons[i % spaceIcons.length]

      return {
        id: i,
        IconSpace,
        size: 15,
        left: Math.random() * 100,
        top: Math.random() * 100,
        duration: Math.random() * 40 + 10,
        delay: Math.random() * 20,
        opacity: Math.random() * 0.4 + 0.1,
      }
    })
  }, [])

  return (
    <div className="pointer-events-none absolute inset-0 overflow-hidden">
      {icons.map(({ id, IconSpace, size, left, top, duration, delay, opacity }) => (
        <Icon
          key={id}
          icon={IconSpace}
          size={size}
          className="absolute stroke-nebula-600 animate-float-icons"
          style={{
            left: `${left}%`,
            top: `${top}%`,
            animationDuration: `${duration}s`,
            animationDelay: `${delay}s`,
            opacity,
          }}
        />
      ))}
    </div>
  )
}
