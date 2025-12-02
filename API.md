## Relatório: APIs públicas da NASA (versão traduzida — PT-BR)

Objetivo: compilar um relatório em português com os endpoints e parâmetros das principais APIs públicas mantidas pela NASA, pronto para uso e referências rápidas.

Observação: este documento foi gerado com base nas APIs públicas conhecidas do portal da NASA (ex.: api.nasa.gov, images-api.nasa.gov, DONKI, NeoWs, EPIC, Earth, Mars Rover, etc.). Pode haver APIs adicionais ou alterações posteriores — para a versão definitiva consulte a documentação oficial em https://api.nasa.gov e nos sites específicos de cada serviço.

--

### Autenticação e limites comuns

- api_key: a maioria das APIs exige um parâmetro `api_key` na query string. Você pode usar a chave pública `DEMO_KEY` para testes (limitada). Para uso em produção, gere uma chave em https://api.nasa.gov.
- Formato: ?api_key=YOUR_KEY
- Rate limiting: varia por API; chaves públicas têm limites baixos. Em caso de uso intensivo, peça maiores cotas junto à NASA conforme instruções na documentação.

--

## 1) Astronomy Picture of the Day (APOD)

- Descrição: retorna a imagem (ou vídeo) do dia com metadata.
- Base endpoint: `https://api.nasa.gov/planetary/apod`
- Parâmetros:
  - `api_key` (string) — obrigatório
  - `date` (YYYY-MM-DD) — opcional; data específica
  - `start_date` (YYYY-MM-DD) — opcional; início de um intervalo
  - `end_date` (YYYY-MM-DD) — opcional; fim de um intervalo
  - `count` (int) — opcional; retorna N imagens aleatórias
  - `thumbs` (boolean) — opcional; quando true, retorna thumbs para vídeos (dependendo do recurso)
- Ex.: `GET https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2020-07-01`
- Observações: quando `start_date`/`end_date` são usados, o endpoint retorna uma lista de objetos.

--

## 2) Mars Rover Photos

- Descrição: fotos tiradas pelos rovers (Curiosity, Opportunity, Spirit) em Marte.
- Base endpoint (fotos): `https://api.nasa.gov/mars-photos/api/v1/rovers/{rover}/photos`
- Outros endpoints úteis:
  - `https://api.nasa.gov/mars-photos/api/v1/rovers/{rover}/latest_photos`
  - `https://api.nasa.gov/mars-photos/api/v1/manifests/{rover}` (manifest do rover)
- Parâmetros (photos):
  - `api_key` (string) — obrigatório
  - `rover` (path) — `curiosity`, `opportunity`, `spirit`
  - `earth_date` (YYYY-MM-DD) — opcional; data terrestre
  - `sol` (int) — opcional; dia marciano
  - `camera` (string) — opcional; ex.: `FHAZ`, `RHAZ`, `MAST`, `CHEMCAM`, `NAVCAM`, `PANCAM`, `MINITES` (varia por rover)
  - `page` (int) — opcional; paginação
- Ex.: `GET https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY`

--

## 3) Near Earth Object Web Service (NeoWs)

- Descrição: informações sobre asteroides e objetos próximos à Terra.
- Base endpoints:
  - Feed: `https://api.nasa.gov/neo/rest/v1/feed`
  - Lookup: `https://api.nasa.gov/neo/rest/v1/neo/{asteroid_id}`
  - Browse: `https://api.nasa.gov/neo/rest/v1/neo/browse`
- Parâmetros (feed):
  - `api_key` (string) — obrigatório
  - `start_date` (YYYY-MM-DD) — opcional (padrão: hoje)
  - `end_date` (YYYY-MM-DD) — opcional (padrão: start_date + 7 dias; limites podem aplicar)
- Observações: o `feed` retorna objetos agrupados por data; o `browse` suporta paginação.

--

## 4) Earth (Imagery & Assets)

- Descrição: imagens de satélite e ativos para coordenadas específicas.
- Endpoints principais:
  - Imagery: `https://api.nasa.gov/planetary/earth/imagery`
  - Assets: `https://api.nasa.gov/planetary/earth/assets`
- Parâmetros (imagery):
  - `api_key` (string) — obrigatório
  - `lat` (float) — obrigatório
  - `lon` (float) — obrigatório
  - `date` (YYYY-MM-DD) — opcional (data da imagem)
  - `dim` (float) — opcional; dimensão da imagem em graus (~0–1)
  - `cloud_score` (boolean) — opcional; quando true, retorna pontuação de nuvens
- Parâmetros (assets):
  - `api_key`, `lat`, `lon`, `begin` e `end` (datas) — para listar assets disponíveis

--

## 5) EPIC (Earth Polychromatic Imaging Camera)

- Descrição: imagens do Earth Polychromatic Imaging Camera a partir do satélite DSCOVR.
- Endpoints:
  - `https://api.nasa.gov/EPIC/api/natural` — imagens naturais
  - `https://api.nasa.gov/EPIC/api/enhanced` — imagens realçadas
  - `https://api.nasa.gov/EPIC/api/natural/date/{date}` — imagens por data
- Parâmetros:
  - `api_key` (string) — obrigatório
  - `date` (YYYY-MM-DD) — opcional (quando aplicável)

--

## 6) Image and Video Library (Biblioteca de Imagens e Vídeos)

- Descrição: pesquisa e acesso ao acervo multimídia da NASA. Observação: essa API não exige `api_key` (em geral pública).
- Base endpoint: `https://images-api.nasa.gov`
- Endpoints:
  - `GET /search` — pesquisa
  - `GET /asset/{nasa_id}` — retorna arquivos/URLs de mídia para um `nasa_id`
  - `GET /metadata/{nasa_id}`
- Parâmetros (`/search`):
  - `q` — termos de busca (texto)
  - `center` — centro NASA (ex.: JPL)
  - `description` — texto na descrição
  - `keywords` — palavras-chave
  - `location` — local
  - `media_type` — `image`, `video`, `audio`
  - `year_start`, `year_end` — intervalo de anos
  - `page` — paginação

--

## 7) DONKI (Space Weather Database of Notifications, Knowledge, Information)

- Descrição: APIs relacionadas a eventos de clima espacial (erupções solares, CMEs, etc.).
- Base: `https://api.nasa.gov/DONKI/` seguido do recurso (ex.: `FLR`, `CME`, `GST`, `WSAEnlil`, `notifications`).
- Exemplos de endpoints:
  - `GET /DONKI/FLR?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD&api_key=...`
  - `GET /DONKI/CME?startDate=...&endDate=...&api_key=...`
- Parâmetros gerais:
  - `api_key` — obrigatório
  - `startDate`, `endDate` — intervalo de datas (YYYY-MM-DD)
  - `eventId` / `observatory` — dependendo do endpoint

--

## 8) EONET (Earth Observatory Natural Event Tracker)

- Descrição: eventos naturais (incêndios, inundações, terremotos) — serviço mantido pela NASA/USGS.
- Base: `https://eonet.gsfc.nasa.gov/api/v3/events` (v3) — consultar documentação específica.
- Parâmetros comuns:
  - `status` (open/closed)
  - `category` (wildfires, volcanoes, etc.)
  - `days` — janela de dias
  - `bbox` — box geográfico
  - `limit` — paginação

--

## 9) TechTransfer (Transferência de Tecnologia)

- Descrição: pesquisa de tecnologias disponíveis para transferência/licenciamento.
- Ex.: existem endpoints para busca de patentes e citações; consulte `https://techtransferapi.nasa.gov` ou a documentação no portal da NASA para rotas detalhadas.

--

## 10) Image/GIBS (Global Imagery Browse Services) e outras

- GIBS fornece mosaicos/serviços WMTS para visualização de imagens (não é um simples endpoint REST de JSON). Para mapas e visualização use GIBS (https://gibs.earthdata.nasa.gov).

--

## Exemplos de uso (resumo)

- Requisição APOD (imagem do dia):
  - `GET https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2021-12-01`
- Requisição Mars Rover (fotos por sol):
  - `GET https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&camera=MAST&api_key=DEMO_KEY`
- Requisição Earth Imagery:
  - `GET https://api.nasa.gov/planetary/earth/imagery?lat=1.5&lon=100.75&date=2014-02-01&dim=0.15&api_key=DEMO_KEY`

--

## Como obter uma API Key

1. Acesse https://api.nasa.gov
2. Preencha o formulário com seu e-mail. Você receberá uma chave (`api_key`) por e-mail.
3. Substitua `DEMO_KEY` pela sua chave nas requisições para evitar limites baixos.

--

## Observações, boas práticas e limitações

- Sempre trate `api_key` como credencial: não a exponha em repositórios públicos.
- Considere cache quando possível (imagens, buscas) para reduzir chamadas.
- Verifique o `Content-Type` das respostas — algumas rotas retornam JSON, outras imagens binárias.
- Em endpoints que retornam listas grandes, use paginação quando suportada.
- Consulte sempre a documentação oficial para parâmetros avançados, limites e mudanças.

--

## Referências úteis

- Portal geral de APIs: https://api.nasa.gov
- Biblioteca de imagens: https://images.nasa.gov/ e `https://images-api.nasa.gov`
- NeoWs: https://api.nasa.gov/ (documentação NeoWs)
- DONKI: https://api.nasa.gov/DONKI
- EPIC: https://epic.gsfc.nasa.gov (e endpoints via api.nasa.gov)
- EONET: https://eonet.gsfc.nasa.gov

--

## Próximos passos sugeridos

- Inserir exemplos de resposta JSON reais por endpoint (posso gerar com base em amostras conhecidas ou consultando a API).
- Gerar arquivo separado `API_NASA_RELATORIO.md` com sumário e links diretos.
- Validar endpoints com chamadas reais (requer permissão para fazer requisições HTTP a partir do ambiente).

Fim do relatório.
