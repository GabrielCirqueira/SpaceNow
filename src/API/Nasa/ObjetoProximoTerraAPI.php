<?php

namespace App\API\Nasa;

use App\Infra\NasaApiClient;
use App\DataObject\Requests\Nasa\ObjetoProximoTerraDTO;
use App\API\TradutorAPI;
use GuzzleHttp\Client;

/**
 * API de Objetos Próximos à Terra - NeoWs (Asteroides)
 * Categoria: NEO - Near Earth Objects
 * Endpoint base: /neo/rest/v1/
 * Docs: https://api.nasa.gov/
 */
class ObjetoProximoTerraAPI extends NasaApiClient
{
    private TradutorAPI $tradutor;

    public function __construct(Client $clientGuzzle, string $nasaApiKey, TradutorAPI $tradutor)
    {
        parent::__construct($clientGuzzle, $nasaApiKey);
        $this->tradutor = $tradutor;
    }

    /**
     * Retorna feed de objetos próximos à Terra em intervalo de datas
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return ObjetoProximoTerraDTO[]
     */
    public function obterFeed(string $dataInicio, string $dataFim): array
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
                $objetos[] = ObjetoProximoTerraDTO::deArray($neo, $this->tradutor);
            }
        }

        return $objetos;
    }

    /**
     * Retorna asteroide específico por ID
     * @param string $idAsteroide ID do asteroide
     * @return ObjetoProximoTerraDTO
     */
    public function obterPorId(string $idAsteroide): ObjetoProximoTerraDTO
    {
        $response = $this->get(endpoint: "neo/rest/v1/neo/{$idAsteroide}");

        return ObjetoProximoTerraDTO::deArray($response, $this->tradutor);
    }

    /**
     * Navega lista paginada de objetos próximos à Terra
     * @param int $pagina Número da página
     * @return ObjetoProximoTerraDTO[]
     */
    public function navegarLista(int $pagina = 0): array
    {
        $params = ['page' => $pagina];
        $response = $this->get(endpoint: "neo/rest/v1/neo/browse", params: $params);

        if (!isset($response['near_earth_objects'])) {
            return [];
        }

        return array_map(
            fn($data) => ObjetoProximoTerraDTO::deArray($data, $this->tradutor),
            $response['near_earth_objects']
        );
    }
}
