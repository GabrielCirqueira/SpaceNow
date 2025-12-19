import { asteroidsConfig } from '@app/components/Particles/AsteroidsBackground/asteroidsConfig'
import type { Engine } from '@tsparticles/engine'
import Particles, { initParticlesEngine } from '@tsparticles/react'
import { loadSlim } from '@tsparticles/slim'
import { useEffect, useState } from 'react'

export function AsteroidsBackground() {
  const [init, setInit] = useState(false)

  useEffect(() => {
    initParticlesEngine(async (engine: Engine) => {
      await loadSlim(engine)
    }).then(() => {
      setInit(true)
    })
  }, [])

  if (!init) {
    return null
  }

  return (
    <Particles
      id="tsparticles"
      style={{
        position: 'absolute',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        zIndex: 0,
      }}
      className="w-full h-full absolute top-0 left-0"
      options={asteroidsConfig}
    />
  )
}
