export interface NasaApod {
  direitosAutorais: string | null
  data: string
  explicacao: string
  explicacaoPT: string
  urlHd: string | null
  tipoMidia: 'image' | 'video'
  versaoServico: string
  titulo: string
  tituloPT: string
  url: string | null
}
