<?php

namespace App\API\Nasa;

use App\Infra\NasaApiClient;
use App\DataObject\Requests\Nasa\ImagemTerraDTO;
use GuzzleHttp\Client;

/**
 * API de Imagens de Satélite da Terra
 * Categoria: Planetary APIs - Earth Imagery & Assets
 * Endpoint base: /planetary/earth/
 * Docs: https://api.nasa.gov/
 */
class ImagemTerraAPI extends NasaApiClient
{
    public function __construct(Client $clientGuzzle, string $nasaApiKey)
    {
        parent::__construct($clientGuzzle, $nasaApiKey);
    }

    /**
     * Retorna imagem de satélite para coordenadas específicas
     * @param float $latitude Latitude
     * @param float $longitude Longitude
     * @param string|null $data Data da imagem (YYYY-MM-DD)
     * @param float|null $dimensao Dimensão em graus
     * @param bool $pontuacaoNuvens Incluir pontuação de nuvens
     * @return ImagemTerraDTO
     */
    public function obterImagem(
        float $latitude,
        float $longitude,
        ?string $data = null,
        ?float $dimensao = null,
        bool $pontuacaoNuvens = false
    ): ImagemTerraDTO {
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
     * Retorna assets disponíveis para coordenadas e período
     * @param float $latitude Latitude
     * @param float $longitude Longitude
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterAssets(
        float $latitude,
        float $longitude,
        string $dataInicio,
        string $dataFim
    ): array {
        $params = [
            'lat' => $latitude,
            'lon' => $longitude,
            'begin' => $dataInicio,
            'end' => $dataFim,
        ];

        $response = $this->get(endpoint: "planetary/earth/assets", params: $params);

        return $response;
    }
}
