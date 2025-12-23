import { api } from '@app/http/config'
import { NasaApod } from '@app/types/Nasa/apod'

export async function getApodDay(): Promise<NasaApod> {
  const { data } = await api.get<NasaApod>('/nasa/apodDay')
  return data
}
