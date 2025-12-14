import { useEffect, useState } from 'react'
import { api } from '../http/config'
import { NasaApod } from './../types/Nasa/apod'

interface ApodResponse {
  dados: NasaApod[]
}

export function useApod() {
  const [apod, setApod] = useState<NasaApod[] | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    async function fetchApod() {
      try {
        const response = await api.get<ApodResponse>('/api/v1/nasa/apod')
        setApod(response.data.dados)
      } catch (err) {
        setError(err instanceof Error ? err : new Error('Unknown error'))
      } finally {
        setLoading(false)
      }
    }
    fetchApod()
  }, [])

  return { apod, loading, error }
}
