<?php

namespace App\API;

use App\Infra\NasaPesquisaApiClient;
use App\DataObject\Requests\Nasa\ResultadoPesquisaDTO;
use App\API\TradutorAPI;
use GuzzleHttp\Client;

/**
 * API de Pesquisa Geral da NASA (imagens, vídeos, áudios)
 */
class PesquisaAPI extends NasaPesquisaApiClient
{
    private TradutorAPI $tradutor;

    public function __construct(Client $clientGuzzle, TradutorAPI $tradutor)
    {
        parent::__construct($clientGuzzle);
        $this->tradutor = $tradutor;
    }

    /**
     * Pesquisa imagens, vídeos e áudios da NASA
     *
     * @param string $query Termo de busca (obrigatório)
     * @param string|null $mediaType Tipo de mídia: 'image', 'video', 'audio'
     * @param int $limit Quantidade de resultados (1-100, padrão: 10)
     * @param string|null $yearStart Ano de início (YYYY)
     * @param string|null $yearEnd Ano de fim (YYYY)
     * @return ResultadoPesquisaDTO
     */
    public function pesquisar(
        string $query,
        ?string $mediaType = null,
        int $limit = 10,
        ?string $yearStart = null,
        ?string $yearEnd = null
    ): ResultadoPesquisaDTO {
        $params = ['q' => $query];

        if ($mediaType !== null) {
            $params['media_type'] = $mediaType;
        }

        $limit = max(1, min(100, $limit));
        $params['page_size'] = $limit;

        if ($yearStart !== null) {
            $params['year_start'] = $yearStart;
        }

        if ($yearEnd !== null) {
            $params['year_end'] = $yearEnd;
        }

        $response = $this->get(endpoint: 'search', params: $params);

        if (empty($response)) {
            return ResultadoPesquisaDTO::deArray([
                'collection' => [
                    'version' => '1.0',
                    'href' => '',
                    'items' => [],
                ]
            ], $this->tradutor);
        }

        return ResultadoPesquisaDTO::deArray($response, $this->tradutor);
    }

    /**
     * @param string $query Termo de busca
     * @param int $limit Quantidade de resultados (1-100, padrão: 10)
     * @return ResultadoPesquisaDTO
     */
    public function pesquisarImagens(string $query, int $limit = 10): ResultadoPesquisaDTO
    {
        return $this->pesquisar($query, 'image', $limit);
    }

    /**
     * Pesquisa apenas vídeos
     * @param string $query Termo de busca
     * @param int $limit Quantidade de resultados (1-100, padrão: 10)
     * @return ResultadoPesquisaDTO
     */
    public function pesquisarVideos(string $query, int $limit = 10): ResultadoPesquisaDTO
    {
        return $this->pesquisar($query, 'video', $limit);
    }
}
