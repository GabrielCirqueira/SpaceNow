import { AppContainer } from '@/layouts'
import { useApod, useApodDay } from '@app/hooks/queries/useApodDay'
import {
  Button,
  Dialog,
  DialogContent,
  DialogDescription,
  SkeletonBlock,
  SkeletonWrapper,
} from '@app/shadcn/components'
import { Icon } from '@app/shadcn/components/icon'
import { Text } from '@app/shadcn/typography'
import type { NasaApod } from '@app/types/Nasa/apod'
import { formatDate } from '@app/utils/formatDate'
import { getImageRandom } from '@app/utils/imageRandom'
import { Box, Container, HStack, Image, VStack } from '@shadcn/layout'
import {
  BadgeInfo,
  Calendar,
  Copyright,
  Info,
  Newspaper,
  Rocket,
  Sparkles,
  Telescope,
} from 'lucide-react'
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
      <DialogContent className="bg-gray-800/35 p-0">
        <Image src={imageUrl} alt={title} className="rounded-sm" />
        <Box className="max-w-3/4 absolute bottom-4 left-1/2 -translate-x-1/2 border-2 border-gray-100 px-5 py-1 rounded-3xl">
          <Text>{title}</Text>
        </Box>
      </DialogContent>
    </Dialog>
  )
}

type ModalApodProps = {
  openModal: boolean
  setOpenModal: (open: boolean) => void
  data: NasaApod
}

const ModalApod = ({ openModal, setOpenModal, data }: ModalApodProps) => {
  if (!data) {
    return
  }

  return (
    <Dialog open={openModal} onOpenChange={setOpenModal}>
      <DialogContent
        className="
          p-0
          w-full rounded-none border-none
          sm:max-w-md
          md:max-w-lg
          lg:max-w-2xl
          "
      >
        <DialogDescription className="w-full">
          <VStack className="gap-5 w-full">
            <HStack className="w-full relative">
              <div className="w-full max-w-5xl aspect-[16/9] overflow-hidden ">
                <Image
                  className="
                  w-full h-full object-cover object-center
                  [mask-image:linear-gradient(to_bottom,black_30%,transparent_100%)]
                  [-webkit-mask-image:linear-gradient(to_bottom,black_60%,transparent_100%)]
                  "
                  src={data?.urlHd ?? getImageRandom()}
                />
              </div>
              <Box className="absolute bottom-4 left-4 flex flex-col gap-4">
                <HStack>
                  <Text className="font-semibold text-gray-100 text-3xl">{data.tituloPT}</Text>
                </HStack>
                <HStack className="gap-5">
                  <Box className="flex flex-row justify-center items-center gap-1">
                    <Icon icon={Calendar} size={15} className="" />
                    <Text className="text-sm">{formatDate(data.data)}</Text>
                  </Box>
                  {data.direitosAutorais && (
                    <Box className="flex flex-row justify-center items-center gap-1">
                      <Icon icon={Copyright} size={15} className="" />
                      <Text className="text-sm">{data.direitosAutorais}</Text>
                    </Box>
                  )}
                </HStack>
              </Box>
            </HStack>

            <HStack className="w-full p-5">
              <Text className="text-justify text-sm md:text-md text-gray-300">
                {data?.explicacaoPT}
              </Text>
            </HStack>
          </VStack>
        </DialogDescription>
      </DialogContent>
    </Dialog>
  )
}

export function Component() {
  const { data, isLoading } = useApodDay()
  const { data: dataApod, isLoading: isLoadingApod } = useApod()
  const [openModalImage, setOpenModalImage] = useState(false)
  const [openModalApod, setOpenModalApod] = useState(false)
  const [selectApod, setSelectApod] = useState<NasaApod | undefined>(undefined)

  console.log(dataApod)

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

        <HStack className="items-start w-full gap-5 flex-col md:flex-row">
          <Box className="flex-1">
            <div className="w-full max-w-5xl aspect-[16/9] overflow-hidden rounded-xl group relative cursor-pointer ">
              <SkeletonWrapper
                isLoading={isLoading}
                className="flex items-center justify-center w-full h-full"
                fallback={<SkeletonBlock className="w-full h-full" />}
              >
                <Box className="flex justify-center items-center">
                  <Image
                    className="w-full h-full object-cover rounded-2xl transition-transform duration-700 group-hover:scale-110 "
                    src={data?.urlHd ?? getImageRandom()}
                  />
                  <div className="absolute inset-0 bg-black/20 opacity-0 transition-opacity duration-300 group-hover:opacity-100" />

                  <Button
                    className="
                      absolute left-1/2 top-2/4 -translate-x-1/2 w-1/3
                      flex items-center justify-center bg-transparent border-2 border-gray-300
                      opacity-0 transition-all duration-700 rounded-3xl
                      group-hover:opacity-100 group-hover:translate-y-0
                    "
                  >
                    <HStack className="justify-center items-center">
                      <Text className="text-gray-300">Abrir em HD</Text>
                    </HStack>
                  </Button>
                </Box>
              </SkeletonWrapper>
            </div>
          </Box>
          <Box className="flex-1">
            <VStack className="h-full gap-5 justify-start items-start">
              <HStack className="w-full">
                <SkeletonWrapper
                  isLoading={isLoading}
                  fallback={<SkeletonBlock className="w-2/4 h-8" />}
                >
                  <Text className="font-bold text-2xl md:text-3xl text-gray-100">
                    {data?.tituloPT}
                  </Text>
                </SkeletonWrapper>
              </HStack>
              <HStack className="w-full">
                <SkeletonWrapper
                  isLoading={isLoading}
                  fallback={<SkeletonBlock className="w-full h-44" />}
                >
                  <Text className="line-clamp-5 text-sm md:text-md text-gray-300 text-justify">
                    {data?.explicacaoPT}
                  </Text>
                </SkeletonWrapper>
              </HStack>
              <HStack className="w-full">
                <SkeletonWrapper
                  isLoading={isLoading}
                  fallback={<SkeletonBlock className="w-1/4 h-10" />}
                >
                  {data?.urlHd && (
                    <Button className="bg-nebula-700 w-1/3" onClick={() => setOpenModalImage(true)}>
                      <Icon icon={BadgeInfo} className="stroke-gray-100" />
                      <Text className="text-gray-100">Ver em HD</Text>
                    </Button>
                  )}
                </SkeletonWrapper>
                <SkeletonWrapper
                  isLoading={isLoading}
                  fallback={<SkeletonBlock className="w-1/4 h-10" />}
                >
                  <Button
                    className="w-1/3 bg-gradient-to-r from-cosmic-500 via-cosmic-600 to-nebula-700"
                    onClick={() => {
                      setSelectApod(data)
                      setOpenModalApod(true)
                    }}
                  >
                    <Icon icon={BadgeInfo} className="stroke-gray-100" />
                    <Text className="text-gray-50">Ver mais</Text>
                  </Button>
                </SkeletonWrapper>
              </HStack>
              <hr className="border-1 border-gray-700 w-full" />
              <HStack className="w-full">
                <SkeletonWrapper
                  isLoading={isLoading}
                  fallback={<SkeletonBlock className="w-1/3 h-7 rounded-2xl" />}
                >
                  <Box className="flex flex-row gap-3 border-gray-500 border-1 px-3 py-1 rounded-3xl">
                    <Icon icon={Calendar} size={16} className="" />
                    <Text className="text-gray-200 text-xs">
                      {data?.data ? formatDate(data.data) : ''}
                    </Text>
                  </Box>
                </SkeletonWrapper>
                <SkeletonWrapper
                  isLoading={isLoading}
                  fallback={<SkeletonBlock className="w-1/3 h-7 rounded-2xl" />}
                >
                  {data?.direitosAutorais && (
                    <Box className="flex flex-row gap-3 border-nebula-600 border-1 px-3 py-1 rounded-3xl">
                      <Icon icon={Copyright} size={16} className="stroke-nebula-600" />
                      <Text className="text-nebula-600 text-xs">{data?.direitosAutorais}</Text>
                    </Box>
                  )}
                </SkeletonWrapper>
              </HStack>
            </VStack>
          </Box>
        </HStack>
      </Container>
      <Container
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
          px-8
      "
      >
        <SkeletonWrapper isLoading={isLoadingApod} fallback={<SkeletonBlock />}>
          <Box className="py-6 grid grid-cols-3 gap-6">
            {dataApod?.map((apod) => (
              <Box key={apod.data} className="bg-black/40 border border-white/20 rounded-lg">
                <VStack className="gap-5 pb-5">
                  <HStack>
                    <div className="w-full max-w-5xl aspect-[16/9] overflow-hidden relative">
                      <Image
                        className="
                          w-full h-full object-cover object-center rounded-lg
                          [mask-image:linear-gradient(to_bottom,black_30%,transparent_100%)]
                          [-webkit-mask-image:linear-gradient(to_bottom,black_60%,transparent_100%)]
                        "
                        src={apod.urlHd ?? apod.url ?? ''}
                      />
                      <Box
                        className="
                          absolute bottom-1 left-2 flex
                          gap-3 bg-cosmic-500/20 border-cosmic-500
                          border-1 px-2 py-1 rounded-xl
                          lex-row justify-center items-center
                        "
                      >
                        <Icon icon={Calendar} size={10} className="stroke-nebula-500" />
                        <Text className="text-gray-200 text-2xs">{formatDate(apod.data)}</Text>
                      </Box>
                    </div>
                  </HStack>
                  <HStack className="px-3">
                    <VStack>
                      <Text className="text-gray-100 font-semibold text-sm line-clamp-3">
                        {apod.tituloPT}
                      </Text>
                      <Text className="text-gray-400 text-xs line-clamp-3 text-justify">
                        {apod.explicacaoPT}
                      </Text>
                    </VStack>
                  </HStack>
                  <HStack className="w-full justify-center">
                    <Button
                      className="
                        w-11/12 bg-gradient-to-r
                        from-cosmic-600 to-nebula-600 hover:from-cosmic-700
                        hover:to-nebula-700 transition-all duration-700 ease-in
                      "
                      onClick={() => {
                        setSelectApod(apod)
                        setOpenModalApod(true)
                      }}
                    >
                      <Icon icon={Info} className="stroke-nebula-100" />
                      <Text className="text-nebula-100 font-semibold">Ver Mais</Text>
                    </Button>
                  </HStack>
                </VStack>
              </Box>
            ))}
          </Box>
        </SkeletonWrapper>
      </Container>
      {data?.urlHd && (
        <ModalImage
          imageUrl={data?.urlHd ?? data?.url}
          setOpenModal={setOpenModalImage}
          openModal={openModalImage}
          title={data.tituloPT}
        />
      )}
      <ModalApod openModal={openModalApod} setOpenModal={setOpenModalApod} data={selectApod} />
    </AppContainer>
  )
}
