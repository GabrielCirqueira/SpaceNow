import axios from 'axios'

export const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? 'http://127.0.0.1:3010/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
})
