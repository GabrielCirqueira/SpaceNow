const imageUrls: string[] = [
  'https://apod.nasa.gov/apod/image/1901/sombrero_spitzer_3000.jpg',
  'https://apod.nasa.gov/apod/image/1901/orionred_WISEantonucci_1824.jpg',
  'https://apod.nasa.gov/apod/image/1901/20190102UltimaThule-pr.png',
  'https://apod.nasa.gov/apod/image/1901/UT-blink_3d_a.gif',
  'https://apod.nasa.gov/apod/image/1901/Jan3yutu2CNSA.jpg',
  'https://apod.nasa.gov/apod/image/1901/vltlaser_beletsky_1400.jpg',
  'https://apod.nasa.gov/apod/image/1901/Geminids46P_jcc_2000.jpg',
  'https://apod.nasa.gov/apod/image/1901/Cuadrantidas30estelasDLopez.jpg',
  'https://apod.nasa.gov/apod/image/1901/Vela-DSS-New-L.jpg',
  'https://apod.nasa.gov/apod/image/1901/Beijing_pse-s.jpg',
  'https://apod.nasa.gov/apod/image/1901/beletsky_waterfall.jpg',
  'https://apod.nasa.gov/apod/image/1901/TychoSNR_Chandra_3600.jpg',
  'https://apod.nasa.gov/apod/image/1901/MeteorMountain_Roemmelt_1371.jpg',
  'https://apod.nasa.gov/apod/image/1901/HeartSoul_Zauner_1952.jpg',
  'https://apod.nasa.gov/apod/image/1901/IC342Medvedevas.jpg',
  'https://apod.nasa.gov/apod/image/1901/KicksledTWAN20190106.jpg',
  'https://apod.nasa.gov/apod/image/1901/Startrail_Funes.jpg',
  'https://apod.nasa.gov/apod/image/1901/TLE2018Jan-seq3w.jpg',
  'https://apod.nasa.gov/apod/image/1901/Selfie_InSight_4391.jpg',
  'https://apod.nasa.gov/apod/image/1901/LunarEclipseCologne_Junius_1280.jpg',
  'https://apod.nasa.gov/apod/image/1901/OrionAlps_Vesely_740.jpg',
  'https://apod.nasa.gov/apod/image/1901/cervin1300vetter.jpg',
  'https://apod.nasa.gov/apod/image/1901/2019_01_21_ZM_Single_crop.jpg',
  'https://apod.nasa.gov/apod/image/1901/LOmbradellaTerraFinazzi.jpg',
  'https://apod.nasa.gov/apod/image/1901/chilepan_buer_1400.jpg',
]

export const getImageRandom = (): string => {
  if (imageUrls.length === 0) return ''

  const random = Math.floor(Math.random() * imageUrls.length)

  return imageUrls[random] ?? ''
}
