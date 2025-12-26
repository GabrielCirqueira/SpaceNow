import { Button } from '@app/shadcn/components/button'
import { Box, HStack } from '@app/shadcn/layout'

const Titulo = () => {
  return (
    <h1
      className="ml-10 font-bold text-3xl tracking-wide 
         bg-gradient-to-r from-cosmic-400 via-cosmic-500 to-nebula-500
         text-transparent bg-clip-text
         glow-cosmic
         "
    >
      Space
      <span className="text-white">Now</span>
    </h1>
  )
}

const HeaderButton = ({ children }) => {
  return (
    <Button
      className="
        px-7
        relative shadow-none text-navy-200
        after:content-[''] after:absolute after:left-1/2 after:-translate-x-1/2
        after:-bottom-1 after:h-[2px]
        after:w-full after:scale-x-0 after:origin-center
        after:bg-gradient-to-r after:from-cosmic-500 after:to-nebula-500
        after:shadow-nebula
        after:transition-transform after:duration-300
        hover:after:scale-x-100
        bg-transparent
        hover:text-nebula-300
        hover:bg-transparent
      "
    >
      {children}
    </Button>
  )
}

const Header = () => {
  return (
    <Box className="py-4">
      <HStack className="w-full justify-between items-center">
        <Titulo />

        <HStack className="absolute left-1/2 -translate-x-1/2 gap-10">
          <HeaderButton>Home</HeaderButton>
          <HeaderButton>APOD</HeaderButton>
          <HeaderButton>Missões</HeaderButton>
          <HeaderButton>Galeria</HeaderButton>
          <HeaderButton>Sobre</HeaderButton>
        </HStack>

        <Box className="w-[100px]" />
      </HStack>
    </Box>
  )
}

export default Header
