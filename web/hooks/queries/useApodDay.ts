import { getApod, getApodDay } from '@app/services'
import { useQuery } from '@tanstack/react-query'

export function useApodDay() {
  return useQuery({
    queryKey: ['apodDay'],
    queryFn: getApodDay,
  })
}

export function useApod() {
  return useQuery({
    queryKey: ['apod'],
    queryFn: getApod,
  })
}
