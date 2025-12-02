<?php

namespace App\API;

use App\Infra\NasaApiClient;
use App\DataObject\Requests\Nasa\ImagemAstronomicaDiaDTO;
use App\DataObject\Requests\Nasa\FotoRoverMarteDTO;
use App\DataObject\Requests\Nasa\ObjetoProximoTerraDTO;
use App\DataObject\Requests\Nasa\ImagemTerraDTO;
use App\DataObject\Requests\Nasa\ImagemEpicDTO;
use App\DataObject\Requests\Nasa\EventoDonkiDTO;
use App\API\TradutorAPI;
use GuzzleHttp\Client;

class NasaAPI extends NasaApiClient
{
    private TradutorAPI $tradutor;

    public function __construct(Client $clientGuzzle, string $nasaApiKey, TradutorAPI $tradutor)
    {
        parent::__construct($clientGuzzle, $nasaApiKey);
        $this->tradutor = $tradutor;
    }

    /**
     * Retorna imagens astronômicas do dia em um intervalo de datas
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return ImagemAstronomicaDiaDTO[]
     */
    public function obterDadosApod(string $dataInicio, string $dataFim): array
    {
        $params = [
            'start_date' => $dataInicio,
            'end_date' => $dataFim,
        ];

        $response = $this->get(endpoint: "planetary/apod", params: $params);

        return array_map(fn($data) => ImagemAstronomicaDiaDTO::deArray($data, $this->tradutor), $response);
    }

    /**
     * Retorna imagem astronômica de uma data específica
     * @param string $data Data (YYYY-MM-DD)
     * @return ImagemAstronomicaDiaDTO
     */
    public function obterApodPorData(string $data): ImagemAstronomicaDiaDTO
    {
        $params = ['date' => $data];
        $response = $this->get(endpoint: "planetary/apod", params: $params);

        return ImagemAstronomicaDiaDTO::deArray($response, $this->tradutor);
    }

    /**
     * Retorna imagens astronômicas aleatórias
     * @param int $quantidade Quantidade de imagens
     * @return ImagemAstronomicaDiaDTO[]
     */
    public function obterApodAleatorio(int $quantidade = 1): array
    {
        $params = ['count' => $quantidade];
        $response = $this->get(endpoint: "planetary/apod", params: $params);

        return array_map(fn($data) => ImagemAstronomicaDiaDTO::deArray($data, $this->tradutor), $response);
    }

    /**
     * Retorna fotos do rover de Marte por sol (dia marciano)
     * @param string $rover Nome do rover (curiosity, opportunity, spirit)
     * @param int $sol Dia marciano
     * @param string|null $camera Câmera específica
     * @param int $pagina Número da página
     * @return FotoRoverMarteDTO[]
     */
    public function obterFotosRoverMartePorSol(string $rover, int $sol, ?string $camera = null, int $pagina = 1): array
    {
        $params = [
            'sol' => $sol,
            'page' => $pagina,
        ];

        if ($camera) {
            $params['camera'] = $camera;
        }

        $response = $this->get(endpoint: "mars-photos/api/v1/rovers/{$rover}/photos", params: $params);

        if (!isset($response['photos'])) {
            return [];
        }

        return array_map(fn($data) => FotoRoverMarteDTO::deArray($data), $response['photos']);
    }

    /**
     * Retorna fotos do rover de Marte por data terrestre
     * @param string $rover Nome do rover
     * @param string $dataTerra Data terrestre (YYYY-MM-DD)
     * @param string|null $camera Câmera específica
     * @param int $pagina Número da página
     * @return FotoRoverMarteDTO[]
     */
    public function obterFotosRoverMartePorDataTerra(string $rover, string $dataTerra, ?string $camera = null, int $pagina = 1): array
    {
        $params = [
            'earth_date' => $dataTerra,
            'page' => $pagina,
        ];

        if ($camera) {
            $params['camera'] = $camera;
        }

        $response = $this->get(endpoint: "mars-photos/api/v1/rovers/{$rover}/photos", params: $params);

        if (!isset($response['photos'])) {
            return [];
        }

        return array_map(fn($data) => FotoRoverMarteDTO::deArray($data), $response['photos']);
    }

    /**
     * Retorna fotos mais recentes do rover de Marte
     * @param string $rover Nome do rover
     * @return FotoRoverMarteDTO[]
     */
    public function obterFotosRecentesRoverMarte(string $rover): array
    {
        $response = $this->get(endpoint: "mars-photos/api/v1/rovers/{$rover}/latest_photos");

        if (!isset($response['latest_photos'])) {
            return [];
        }

        return array_map(fn($data) => FotoRoverMarteDTO::deArray($data), $response['latest_photos']);
    }

    /**
     * Retorna feed de objetos próximos à Terra
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return ObjetoProximoTerraDTO[]
     */
    public function obterFeedObjetosProximosTerra(string $dataInicio, string $dataFim): array
    {
        $params = [
            'start_date' => $dataInicio,
            'end_date' => $dataFim,
        ];

        $response = $this->get(endpoint: "neo/rest/v1/feed", params: $params);

        if (!isset($response['near_earth_objects'])) {
            return [];
        }

        $objetos = [];
        foreach ($response['near_earth_objects'] as $data => $neoArray) {
            foreach ($neoArray as $neo) {
                $objetos[] = ObjetoProximoTerraDTO::deArray($neo);
            }
        }

        return $objetos;
    }

    /**
     * Retorna asteroide específico por ID
     * @param string $idAsteroide ID do asteroide
     * @return ObjetoProximoTerraDTO
     */
    public function obterObjetoProximoTerraPorId(string $idAsteroide): ObjetoProximoTerraDTO
    {
        $response = $this->get(endpoint: "neo/rest/v1/neo/{$idAsteroide}");

        return ObjetoProximoTerraDTO::deArray($response);
    }

    /**
     * Retorna lista de objetos próximos à Terra com paginação
     * @param int $pagina Número da página
     * @return ObjetoProximoTerraDTO[]
     */
    public function navegarObjetosProximosTerra(int $pagina = 0): array
    {
        $params = ['page' => $pagina];
        $response = $this->get(endpoint: "neo/rest/v1/neo/browse", params: $params);

        if (!isset($response['near_earth_objects'])) {
            return [];
        }

        return array_map(fn($data) => ObjetoProximoTerraDTO::deArray($data), $response['near_earth_objects']);
    }

    /**
     * Retorna imagem de satélite da Terra para coordenadas específicas
     * @param float $latitude Latitude
     * @param float $longitude Longitude
     * @param string|null $data Data da imagem (YYYY-MM-DD)
     * @param float|null $dimensao Dimensão em graus
     * @param bool $pontuacaoNuvens Incluir pontuação de nuvens
     * @return ImagemTerraDTO
     */
    public function obterImagemTerra(float $latitude, float $longitude, ?string $data = null, ?float $dimensao = null, bool $pontuacaoNuvens = false): ImagemTerraDTO
    {
        $params = [
            'lat' => $latitude,
            'lon' => $longitude,
        ];

        if ($data) {
            $params['date'] = $data;
        }

        if ($dimensao) {
            $params['dim'] = $dimensao;
        }

        if ($pontuacaoNuvens) {
            $params['cloud_score'] = 'true';
        }

        $response = $this->get(endpoint: "planetary/earth/imagery", params: $params);

        return ImagemTerraDTO::deArray($response);
    }

    /**
     * Retorna assets disponíveis da Terra para coordenadas e período
     * @param float $latitude Latitude
     * @param float $longitude Longitude
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterAssetsTerra(float $latitude, float $longitude, string $dataInicio, string $dataFim): array
    {
        $params = [
            'lat' => $latitude,
            'lon' => $longitude,
            'begin' => $dataInicio,
            'end' => $dataFim,
        ];

        $response = $this->get(endpoint: "planetary/earth/assets", params: $params);

        return $response;
    }

    /**
     * Retorna imagens EPIC naturais mais recentes
     * @return ImagemEpicDTO[]
     */
    public function obterImagensEpicNaturais(): array
    {
        $response = $this->get(endpoint: "EPIC/api/natural");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data), $response);
    }

    /**
     * Retorna imagens EPIC realçadas mais recentes
     * @return ImagemEpicDTO[]
     */
    public function obterImagensEpicRealcadas(): array
    {
        $response = $this->get(endpoint: "EPIC/api/enhanced");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data), $response);
    }

    /**
     * Retorna imagens EPIC naturais de uma data específica
     * @param string $data Data (YYYY-MM-DD)
     * @return ImagemEpicDTO[]
     */
    public function obterImagensEpicNaturaisPorData(string $data): array
    {
        $response = $this->get(endpoint: "EPIC/api/natural/date/{$data}");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data), $response);
    }

    /**
     * Retorna imagens EPIC realçadas de uma data específica
     * @param string $data Data (YYYY-MM-DD)
     * @return ImagemEpicDTO[]
     */
    public function obterImagensEpicRealcadasPorData(string $data): array
    {
        $response = $this->get(endpoint: "EPIC/api/enhanced/date/{$data}");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data), $response);
    }

    /**
     * Retorna eventos de erupções solares DONKI
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return EventoDonkiDTO[]
     */
    public function obterErupcoeSolaresDonki(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/FLR", params: $params);

        return array_map(fn($data) => EventoDonkiDTO::deArray($data), $response);
    }

    /**
     * Retorna eventos de ejeção de massa coronal DONKI
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterEjecaoMassaCoronalDonki(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/CME", params: $params);

        return $response;
    }

    /**
     * Retorna eventos de tempestades geomagnéticas DONKI
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterTempestadesGeomagneticasDonki(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/GST", params: $params);

        return $response;
    }

    /**
     * Retorna notificações de eventos DONKI
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @param string|null $tipo Tipo de notificação
     * @return array
     */
    public function obterNotificacoesDonki(string $dataInicio, string $dataFim, ?string $tipo = null): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        if ($tipo) {
            $params['type'] = $tipo;
        }

        $response = $this->get(endpoint: "DONKI/notifications", params: $params);

        return $response;
    }
}
