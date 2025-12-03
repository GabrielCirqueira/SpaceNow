import { AppContainer } from '@/layouts'
import { Box, Container, Grid } from '@/shadcn/components/ui/layout'
import { Text, Title } from '@/shadcn/components/ui/typography'
import { useApod } from '@app/hooks/useApod'

export function Component() {
  const { apod } = useApod()

  console.log('dados APOD', apod)
  return (
    <AppContainer paddingX="0" className="min-h-screen transition-colors duration-500 w-full">
      <Container size="xl" className="py-8">
        <Grid cols="grid-cols-1 md:grid-cols-2 lg:grid-cols-3" gap="gap-6">
          {apod &&
            apod.map((item, index) => (
              <Box
                key={index}
                className="bg-gray-800 rounded-lg overflow-hidden shadow-lg hover:shadow-2xl transition-shadow duration-300"
              >
                <Box className="relative h-48 w-full bg-gray-900">
                  <img
                    src={item.urlHd}
                    alt={item.tituloPT}
                    className="w-full h-full object-cover"
                  />
                </Box>

                <Box className="p-4 space-y-3">
                  <Title as="h3" size="xl" className="text-white line-clamp-2">
                    {item.tituloPT}
                  </Title>

                  <Text size="sm" className="text-gray-300 line-clamp-3">
                    {item.explicacaoPT}
                  </Text>

                  <a
                    href={item.urlHd}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-block text-blue-400 hover:text-blue-300 text-sm font-medium transition-colors"
                  >
                    Ver imagem completa →
                  </a>
                </Box>
              </Box>
            ))}
        </Grid>
      </Container>
    </AppContainer>
  )
}
