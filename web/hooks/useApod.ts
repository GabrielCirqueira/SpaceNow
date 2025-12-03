import { useEffect, useState } from 'react'
import { api } from '../http/config'
import { NasaApod } from './../types/Nasa/apod'

export function useApod() {
  const [apod, setApod] = useState<NasaApod[] | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    async function fetchApod() {
      try {
        const response = await api.get<NasaApod[]>('/api/v1/nasa/apod')
        setApod(response.data.dados)
      } catch (error) {
        setError(error)
      } finally {
        setLoading(false)
      }
    }
    fetchApod()
  }, [])

  return { apod, loading, error }
}
