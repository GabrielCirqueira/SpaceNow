<?php

namespace App\API\Nasa;

use App\Infra\NasaApiClient;
use App\DataObject\Requests\Nasa\ImagemEpicDTO;
use App\API\TradutorAPI;
use GuzzleHttp\Client;

/**
 * API da Câmera EPIC - Earth Polychromatic Imaging Camera
 * Categoria: EPIC - Imagens policromáticas da Terra
 * Endpoint base: /EPIC/api/
 * Docs: https://api.nasa.gov/
 */
class CameraEpicAPI extends NasaApiClient
{
    private TradutorAPI $tradutor;

    public function __construct(Client $clientGuzzle, string $nasaApiKey, TradutorAPI $tradutor)
    {
        parent::__construct($clientGuzzle, $nasaApiKey);
        $this->tradutor = $tradutor;
    }

    /**
     * Retorna imagens naturais mais recentes
     * @return ImagemEpicDTO[]
     */
    public function obterImagensNaturais(): array
    {
        $response = $this->get(endpoint: "EPIC/api/natural");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data, $this->tradutor), $response);
    }

    /**
     * Retorna imagens realçadas mais recentes
     * @return ImagemEpicDTO[]
     */
    public function obterImagensRealcadas(): array
    {
        $response = $this->get(endpoint: "EPIC/api/enhanced");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data, $this->tradutor), $response);
    }

    /**
     * Retorna imagens naturais de uma data específica
     * @param string $data Data (YYYY-MM-DD)
     * @return ImagemEpicDTO[]
     */
    public function obterImagensNaturaisPorData(string $data): array
    {
        $response = $this->get(endpoint: "EPIC/api/natural/date/{$data}");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data, $this->tradutor), $response);
    }

    /**
     * Retorna imagens realçadas de uma data específica
     * @param string $data Data (YYYY-MM-DD)
     * @return ImagemEpicDTO[]
     */
    public function obterImagensRealcadasPorData(string $data): array
    {
        $response = $this->get(endpoint: "EPIC/api/enhanced/date/{$data}");

        return array_map(fn($data) => ImagemEpicDTO::deArray($data, $this->tradutor), $response);
    }
}
