import { Button } from '@app/shadcn/components/ui/button'
import { Box, HStack } from '@app/shadcn/components/ui/layout'

const Titulo = () => {
  return (
    <h1
      className="ml-10 font-bold text-3xl tracking-wide 
         bg-gradient-to-r from-[#1e90ff] via-[#6a5acd] to-[#9d4edd]
         text-transparent bg-clip-text
         drop-shadow-[0_0_2px_rgba(100,70,255,0.7)]
         "
    >
      Space
      <span className="text-gray-300">Now</span>
    </h1>
  )
}

const HeaderButton = ({ children }) => {
  return (
    <Button
      className="
        relative shadow-none
        after:content-[''] after:absolute after:left-1/2 after:-translate-x-1/2
        after:-bottom-1 after:h-[2px]
        after:w-full after:scale-x-0 after:origin-center
        after:bg-gradient-to-r after:from-[#4f8dff] after:to-[#9d4edd]
        after:shadow-[0_0_8px_rgba(140,70,255,0.8)]
        after:transition-transform after:duration-300
        hover:after:scale-x-100
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
          <HeaderButton>Sobre</HeaderButton>
          <HeaderButton>Info</HeaderButton>
        </HStack>

        <Box className="w-[100px]" />
      </HStack>
    </Box>
  )
}

export default Header
