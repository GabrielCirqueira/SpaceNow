import { AppContainer } from '@/layouts'
import { useApod } from '@app/hooks/useApod'
import { Icon } from '@app/shadcn/components/icon'
import { Text } from '@app/shadcn/typography'
import { Box, Container, HStack } from '@shadcn/layout'
import { Newspaper, Rocket, Sparkles, Telescope } from 'lucide-react'

export function Component() {
  const { apod } = useApod()

  console.log('dados APOD', apod)
  return (
    <AppContainer paddingX="0" className="min-h-screen transition-colors duration-500 w-full">
      <div className="pointer-events-none absolute top-1/4 -left-32 h-[500px] w-[500px] bg-cosmic-700 opacity-20 blur-[120px] rounded-full animate-pulse" />
      <div className="pointer-events-none absolute bottom-1/4 -right-32 h-[500px] w-[500px] bg-nebula-700 opacity-20 blur-[120px] rounded-full animate-pulse" />

      <Container size="xl" className="py-8 flex flex-col items-center justify-center gap-20">
        <Box className="flex flex-row bg-navy-500 py-2 px-10 rounded-3xl border-gray-700 border-2 w-fit gap-2 justify-center align-center">
          <Icon icon={Sparkles} className="stroke-nebula-500 size-5 animate-pulse" />
          <Text className="text-gray-200">
            Notícias, descobertas e missões da NASA em um só lugar
          </Text>
        </Box>
        <Box>
          <Text className="text-5xl sm:text-6xl md:text-7xl lg:text-8xl font-bold animate-in fade-in slide-in-from-bottom-6 duration-700 ease-out text-gray-100">
            Explore o <span className="text-cosmic-500">Universo</span>
          </Text>
        </Box>

        <Box>
          <Text className="text-3xl text-center text-gray-200 animate-in fade-in slide-in-from-bottom-6 duration-700 ease-out">
            As últimas descobertas, missões e maravilhas do <br /> cosmos
          </Text>
        </Box>

        <Box className="flex items-center justify-center">
          <HStack className="gap-12 animate-float">
            <Box className="flex flex-row gap-3 justify-center items-center">
              <Icon icon={Newspaper} className="stroke-nebula-700 size-4" />
              <Text className="text-gray-400 text-sm">Atualizado em tempo real</Text>
            </Box>

            <Box className="flex flex-row gap-3 justify-center items-center">
              <Icon icon={Telescope} className="stroke-nebula-700 size-4" />
              <Text className="text-gray-400 text-sm">Dados oficiais da NASA</Text>
            </Box>

            <Box className="flex flex-row gap-3 justify-center items-center">
              <Icon icon={Rocket} className="stroke-nebula-700 size-4" />
              <Text className="text-gray-400 text-sm">Exploração espacial</Text>
            </Box>
          </HStack>
        </Box>
      </Container>
    </AppContainer>
  )
}
