import react from '@vitejs/plugin-react'
import path from 'path'
import { defineConfig } from 'vite'
import symfonyPlugin from 'vite-plugin-symfony'
import tsconfigPaths from 'vite-tsconfig-paths'

const frontendPort = Number.parseInt(process.env.FRONTEND_PORT ?? '', 10) || 5173

export default defineConfig((config) => ({
  plugins: [
    react(),
    symfonyPlugin(),
    tsconfigPaths(),
  ],
  resolve: {
    alias: {
      '@app': path.resolve(__dirname, './web'),
      '@': path.resolve(__dirname, './web'),
      '@components': path.resolve(__dirname, './web/components'),
      '@pages': path.resolve(__dirname, './web/pages'),
      '@themes': path.resolve(__dirname, './web/themes'),
      '@layouts': path.resolve(__dirname, './web/layouts'),
      '@shadcn/lib': path.resolve(__dirname, './web/shadcn/lib'),
      '@shadcn/hooks': path.resolve(__dirname, './web/shadcn/hooks'),
      '@shadcn/layout': path.resolve(__dirname, './web/shadcn/layout'),
      '@shadcn/typography': path.resolve(__dirname, './web/shadcn/typography'),
      '@shadcn/components': path.resolve(__dirname, './web/shadcn/components'),
      '@shadcn': path.resolve(__dirname, './web/shadcn'),
    },
  },
  build: {
    rollupOptions: {
      input: {
        app: './web/main.tsx',
      },
    },
    sourcemap: config.mode === 'development',
  },
  server: {
    hmr: {
      host: 'localhost',
      port: frontendPort,
    },
    port: frontendPort,
  },

}))
