import { ThemeProvider } from '@/contexts'
import { MainLayout } from '@app/layouts'
import { queryClient } from '@app/lib/queryClient'
import { QueryClientProvider } from '@tanstack/react-query'
import {
  Route,
  RouterProvider,
  createBrowserRouter,
  createRoutesFromElements,
} from 'react-router-dom'

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/">
      <Route element={<MainLayout />}>
        <Route index lazy={() => import('@pages/Home/Home')} />
        <Route path="*" lazy={() => import('@pages/NotFound/NotFound')} />
      </Route>
    </Route>
  )
)

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <RouterProvider router={router} />
      </ThemeProvider>
    </QueryClientProvider>
  )
}
