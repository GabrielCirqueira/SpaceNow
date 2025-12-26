export function formatDate(dateString: string): string {
  if (!dateString) return ''

  const date = new Date(`${dateString}T00:00:00`)

  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  })
    .format(date)
    .replace(/^(\d{2})/, (d) => d.replace(/^0/, ''))
}
