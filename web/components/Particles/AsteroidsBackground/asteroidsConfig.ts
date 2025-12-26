import type { ISourceOptions } from '@tsparticles/engine'

export const asteroidsConfig: ISourceOptions = {
  background: {
    color: 'transparent',
  },

  fullScreen: {
    enable: false,
    zIndex: 0,
  },

  particles: {
    number: {
      value: 50,
    },

    color: {
      value: '#ffffff',
    },

    shape: {
      type: 'circle',
    },

    opacity: {
      value: 1,
    },

    size: {
      value: { min: 3, max: 6 },
    },

    move: {
      enable: true,
      speed: { min: 5, max: 15 },
      direction: 'bottomRight',
      straight: false,
      outModes: {
        default: 'out',
      },
    },
  },
}
