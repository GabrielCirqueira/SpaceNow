<?php

namespace App\API\Nasa;

use App\Infra\NasaApiClient;
use App\DataObject\Requests\Nasa\EventoDonkiDTO;
use App\API\TradutorAPI;
use GuzzleHttp\Client;

/**
 * API de Clima Espacial - DONKI
 * Database Of Notifications, Knowledge, Information
 * Categoria: DONKI - Space Weather
 * Endpoint base: /DONKI/
 * Docs: https://api.nasa.gov/
 */
class ClimaEspacialAPI extends NasaApiClient
{
    private TradutorAPI $tradutor;

    public function __construct(Client $clientGuzzle, string $nasaApiKey, TradutorAPI $tradutor)
    {
        parent::__construct($clientGuzzle, $nasaApiKey);
        $this->tradutor = $tradutor;
    }

    /**
     * Retorna eventos de erupções solares (Solar Flares - FLR)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return EventoDonkiDTO[]
     */
    public function obterErupcoesSolares(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/FLR", params: $params);

        return array_map(fn($data) => EventoDonkiDTO::deArray($data, $this->tradutor), $response);
    }

    /**
     * Retorna eventos de ejeção de massa coronal (CME)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterEjecaoMassaCoronal(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/CME", params: $params);

        return $response;
    }

    /**
     * Retorna eventos de tempestades geomagnéticas (GST)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterTempestadesGeomagneticas(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/GST", params: $params);

        return $response;
    }

    /**
     * Retorna simulações WSA+Enlil
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterSimulacoesWSAEnlil(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/WSAEnlilSimulation", params: $params);

        return $response;
    }

    /**
     * Retorna eventos SEP (Solar Energetic Particle)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterEventosSEP(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/SEP", params: $params);

        return $response;
    }

    /**
     * Retorna eventos IPS (Interplanetary Shocks)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterChoquesInterplanetarios(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/IPS", params: $params);

        return $response;
    }

    /**
     * Retorna eventos MPC (Magnetopause Crossing)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterCruzamentosMagnetopausa(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/MPC", params: $params);

        return $response;
    }

    /**
     * Retorna eventos RBE (Radiation Belt Enhancements)
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @return array
     */
    public function obterMelhoriasCinturaoRadiacao(string $dataInicio, string $dataFim): array
    {
        $params = [
            'startDate' => $dataInicio,
            'endDate' => $dataFim,
        ];

        $response = $this->get(endpoint: "DONKI/RBE", params: $params);

        return $response;
    }

    /**
     * Retorna notificações de eventos
     * @param string $dataInicio Data inicial (YYYY-MM-DD)
     * @param string $dataFim Data final (YYYY-MM-DD)
     * @param string|null $tipo Tipo de notificação
     * @return array
     */
    public function obterNotificacoes(string $dataInicio, string $dataFim, ?string $tipo = null): array
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
