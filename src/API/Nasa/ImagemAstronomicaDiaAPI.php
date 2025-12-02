<?php

namespace App\API\Nasa;

use App\Infra\NasaApiClient;
use App\DataObject\Requests\Nasa\ImagemAstronomicaDiaDTO;
use App\API\TradutorAPI;
use GuzzleHttp\Client;

/**
 * API de Imagens Astronômicas do Dia (APOD)
 * Categoria: Planetary APIs
 * Endpoint base: /planetary/apod
 * Docs: https://api.nasa.gov/
 */
class ImagemAstronomicaDiaAPI extends NasaApiClient
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
    public function obterPorPeriodo(string $dataInicio, string $dataFim): array
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
    public function obterPorData(string $data): ImagemAstronomicaDiaDTO
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
    public function obterAleatorio(int $quantidade = 1): array
    {
        $params = ['count' => $quantidade];
        $response = $this->get(endpoint: "planetary/apod", params: $params);

        return array_map(fn($data) => ImagemAstronomicaDiaDTO::deArray($data, $this->tradutor), $response);
    }
}
