import { api } from '@app/http/config'
import type { NasaApod } from '@app/types/Nasa/apod'

export async function getApodDay(): Promise<NasaApod> {
  const { data } = await api.get<NasaApod>('/nasa/apodDay')
  return data
}

export async function getApod(): Promise<NasaApod[]> {
  const { data } = await api.get<NasaApod[]>('/nasa/apod')
  return data
}
