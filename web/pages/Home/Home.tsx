import { AppContainer } from '@/layouts'
import { useApodDay } from '@app/hooks/queries/useApodDay'
import { Button } from '@app/shadcn/components'
import { Icon } from '@app/shadcn/components/icon'
import { Text } from '@app/shadcn/typography'
import { formatDate } from '@app/utils/formatDate'
import { getImageRandom } from '@app/utils/imageRandom'
import { Box, Container, HStack, Image, VStack } from '@shadcn/layout'
import { BadgeInfo, Calendar, Newspaper, Rocket, Sparkles, Telescope } from 'lucide-react'

export function Component() {
  const { data } = useApodDay()

  console.log(data)

  console.log('dados APOD', data)
  return (
    <AppContainer
      paddingX="0"
      className="flex flex-col gap-44 min-h-screen transition-colors duration-500 w-full"
    >
      <div className="pointer-events-none absolute top-1/4 -left-32 h-[500px] w-[500px] bg-cosmic-700 opacity-20 blur-[120px] rounded-full animate-pulse" />
      <div className="pointer-events-none absolute bottom-1/4 -right-32 h-[500px] w-[500px] bg-nebula-700 opacity-20 blur-[120px] rounded-full animate-pulse" />

      <Container className="py-8 flex flex-col items-center justify-center gap-20">
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

      <Container
        size="xl"
        className="py-8 flex flex-col items-center justify-center gap-7 bg-red-5100"
      >
        <HStack className="itens-start w-full">
          <Box className="border-blue-600 border-2 py-2 px-5 rounded-3xl">
            <HStack>
              <Icon icon={Calendar} className="stroke-blue-500" />
              <Text className="text-blue-500">APOD - IMAGEM ASTRONÔMICA DO DIA</Text>
            </HStack>
          </Box>
        </HStack>

        <HStack className="itens-start w-full">
          <VStack>
            <Text className="text-5xl font-bold animate-in fade-in duration-700 ease-out text-gray-100">
              A maravilha de <span className="text-cosmic-500">Hoje</span>
            </Text>
            <Text className="text-gray-400">
              Todos os dias a NASA, seleciona uma imagem ou video impressionante do <br /> Univerno
            </Text>
          </VStack>
        </HStack>

        <HStack className="itens-start w-full items-stretch gap-5">
          <Box className="flex-1">
            <div className="w-full max-w-5xl aspect-[16/9] overflow-hidden rounded-xl">
              <Image
                className="w-full h-full object-cover object-center rounded-2xl glow-cosmic-as border-gray-700 border-2"
                src={data?.urlHd ?? getImageRandom()}
              />
            </div>
          </Box>

          <Box className="flex-1 h-10">
            <VStack className="h-full gap-5">
              <HStack>
                <Text className="font-bold text-2xl">{data?.tituloPT}</Text>
              </HStack>
              <HStack>
                <Text className="line-clamp-5 text-md text-gray-300">{data?.explicacaoPT}</Text>
              </HStack>
              <HStack>
                <Button className=" bg-gradient-to-r from-cosmic-500 via-cosmic-600 to-nebula-700">
                  <Icon icon={BadgeInfo} className="text-gray-100" />
                  <Text className="text-gray-100">Ver mais</Text>
                </Button>
              </HStack>
              <hr className="border-1 border-gray-700 w-full" />
              <HStack>
                <Box className="flex flex-row gap-3 border-gray-500 border-1 px-3 py-1 rounded-3xl">
                  <Icon icon={Calendar} size={16} className="" />
                  <Text className="text-gray-200 text-xs">{formatDate(data?.data)}</Text>
                </Box>
              </HStack>
            </VStack>
          </Box>
        </HStack>
      </Container>
    </AppContainer>
  )
}
