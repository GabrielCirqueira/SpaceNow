<?php

namespace App\API\Nasa;

use App\API\TradutorAPI;
use App\DataObject\Requests\Nasa\ImagemAstronomicaDiaDTO;
use App\Infra\NasaApiClient;
use GuzzleHttp\Client;

/**
 * API de Imagens Astronômicas do Dia (APOD)
 * Categoria: Planetary APIs
 * Endpoint base: /planetary/apod
 * Docs: https://api.nasa.gov/.
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
     * Retorna imagens astronômicas do dia em um intervalo de datas.
     *
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim    Data final (YYYY-MM-DD)
     *
     * @return ImagemAstronomicaDiaDTO[]
     */
    public function obterPorPeriodo(string $dataInicio, string $dataFim): array
    {
        $params = [
            'start_date' => $dataInicio,
            'end_date' => $dataFim,
        ];

        $response = $this->get(endpoint: 'planetary/apod', params: $params);

        return array_map(
            fn ($data) => ImagemAstronomicaDiaDTO::deArray($data, $this->tradutor),
            $response,
        );
    }

    /**
     * Retorna imagem astronômica de uma data específica.
     *
     * @param string $data Data (YYYY-MM-DD)
     */
    public function obterPorData(string $data): ImagemAstronomicaDiaDTO
    {
        $params = ['date' => $data];
        $response = $this->get(endpoint: 'planetary/apod', params: $params);

        return ImagemAstronomicaDiaDTO::deArray($response, $this->tradutor);
    }

    /**
     * Retorna imagens astronômicas aleatórias.
     *
     * @param int $quantidade Quantidade de imagens
     *
     * @return ImagemAstronomicaDiaDTO[]
     */
    public function obterAleatorio(int $quantidade = 1): array
    {
        $params = ['count' => $quantidade];
        $response = $this->get(endpoint: 'planetary/apod', params: $params);

        return array_map(
            fn ($data) => ImagemAstronomicaDiaDTO::deArray($data, $this->tradutor),
            $response,
        );
    }

    /**
     * Retorna os últimos N registros (a partir de hoje ou de uma data final informada).
     *
     * @param int         $limit   Quantidade de registros desejada (>= 1)
     * @param string|null $dataFim Data final no formato YYYY-MM-DD (opcional). Se não informada, usa hoje.
     *
     * @return ImagemAstronomicaDiaDTO[]
     *
     * @throws \InvalidArgumentException
     */
    public function obterUltimos(int $limit, ?string $dataFim = null): array
    {
        if ($limit < 1) {
            throw new \InvalidArgumentException('O parâmetro $limit deve ser maior ou igual a 1.');
        }

        $end = $dataFim ? new \DateTimeImmutable($dataFim) : new \DateTimeImmutable('now');
        $endStr = $end->format('Y-m-d');

        $days = $limit - 1;
        $intervalSpec = 'P'.$days.'D';
        $start = $end->sub(new \DateInterval($intervalSpec));
        $startStr = $start->format('Y-m-d');

        $registros = $this->obterPorPeriodo($startStr, $endStr);

        $registros = array_map(function ($item) {
            if ($item instanceof ImagemAstronomicaDiaDTO) {
                return $item;
            }

            return ImagemAstronomicaDiaDTO::deArray((array) $item, $this->tradutor);
        }, $registros);

        usort($registros, function (ImagemAstronomicaDiaDTO $a, ImagemAstronomicaDiaDTO $b) {
            return strcmp($b->obterData() ?? '', $a->obterData() ?? '');
        });

        if (count($registros) > $limit) {
            $registros = array_slice($registros, 0, $limit);
        }

        return $registros;
    }
}
