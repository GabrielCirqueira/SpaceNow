import { AppContainer } from '@/layouts'
import { useApodDay } from '@app/hooks/queries/useApodDay'
import { Button, Dialog, DialogContent, DialogHeader, DialogTitle } from '@app/shadcn/components'
import { Icon } from '@app/shadcn/components/icon'
import { Text } from '@app/shadcn/typography'
import { formatDate } from '@app/utils/formatDate'
import { getImageRandom } from '@app/utils/imageRandom'
// Removido import direto do Radix para evitar mistura de primitives
import { Box, Container, HStack, Image, VStack } from '@shadcn/layout'
import { BadgeInfo, Calendar, Newspaper, Rocket, Sparkles, Telescope } from 'lucide-react'
import { useState } from 'react'

type ModalImageProps = {
  openModal: boolean
  setOpenModal: (open: boolean) => void
  imageUrl: string
  title: string
}

const ModalImage = ({ openModal, setOpenModal, imageUrl, title }: ModalImageProps) => {
  return (
    <Dialog open={openModal} onOpenChange={setOpenModal}>
      <DialogContent className="bg-gray-800/35">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
        </DialogHeader>
        <hr className="border-1 border-gray-700 w-full" />

        <Image src={imageUrl} alt={title} className="rounded-sm" />
      </DialogContent>
    </Dialog>
  )
}

export function Component() {
  const { data } = useApodDay()
  const [openModalImage, setOpenModalImage] = useState(false)

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
        className="
          flex flex-col items-start
          justify-start gap-7
          bg-red-5100 relative
          mx-auto
          max-w-7xl
          rounded-3xl
          bg-black/10
          backdrop-blur-xl
          animate-float-1
          border border-white/10
          px-8 py-12"
      >
        <HStack className="w-full">
          <Box className="border-blue-600 border-2 py-2 px-5 rounded-3xl">
            <HStack>
              <Icon icon={Calendar} className="stroke-blue-500" />
              <Text className="text-blue-500">APOD - IMAGEM ASTRONÔMICA DO DIA</Text>
            </HStack>
          </Box>
        </HStack>

        <HStack className="items-start w-full">
          <VStack className="items-start gap-3 max-w-3xl">
            <Text className="text-5xl sm:text-6xl font-bold animate-in fade-in duration-700 ease-out text-gray-100">
              A maravilha de <span className="text-cosmic-500">Hoje</span>
            </Text>
            <Text className="text-lg text-gray-300">
              Todos os dias a NASA seleciona uma imagem ou vídeo impressionante do Universo.
            </Text>
          </VStack>
        </HStack>

        <HStack className="items-start w-full items-stretch gap-5 flex-col md:flex-row">
          <Box className="flex-1">
            <div className="w-full max-w-5xl aspect-[16/9] glow-cosmic-as overflow-hidden rounded-xl">
              <Image
                className="w-full h-full object-cover object-center rounded-2xl"
                src={data?.urlHd ?? getImageRandom()}
              />
            </div>
          </Box>
          <Box className="flex-1">
            <VStack className="h-full gap-5 justify-start items-start">
              <HStack className="w-full">
                <Text className="font-bold text-2xl md:text-3xl text-gray-100">
                  {data?.tituloPT}
                </Text>
              </HStack>
              <HStack className="w-full">
                <Text className="line-clamp-5 text-sm md:text-md text-gray-300">
                  {data?.explicacaoPT}
                </Text>
              </HStack>
              <HStack className="w-full">
                {data?.urlHd && (
                  <Button className="bg-nebula-700" onClick={() => setOpenModalImage(true)}>
                    <Icon icon={BadgeInfo} className="stroke-gray-100" />
                    <Text className="text-gray-100">Ver em HD</Text>
                  </Button>
                )}
                <Button className=" bg-gradient-to-r from-cosmic-500 via-cosmic-600 to-nebula-700">
                  <Icon icon={BadgeInfo} className="stroke-gray-100" />
                  <Text className="text-gray-50">Ver mais</Text>
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
      {data?.urlHd && (
        <ModalImage
          imageUrl={data?.urlHd ?? data?.url}
          setOpenModal={setOpenModalImage}
          openModal={openModalImage}
          title={data.tituloPT}
        />
      )}
    </AppContainer>
  )
}
