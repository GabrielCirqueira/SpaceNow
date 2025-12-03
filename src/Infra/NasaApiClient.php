<?php

namespace App\Infra;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;

class NasaApiClient
{
    public function __construct(private Client $clientGuzzle, private string $nasaApiKey) {}

    /**
     * @param string $endpoint
     * @param array<string,mixed> $params
     * @return array<string,mixed>
     */
    public function get(string $endpoint, array $params = []): array
    {
        $params['api_key'] = $this->nasaApiKey;

        try {
            $response = $this->clientGuzzle->get($endpoint, [
                'query' => $params,
            ]);

            $decoded = json_decode($response->getBody()->getContents(), true);

            if (!is_array($decoded)) {
                return [];
            }

            return $decoded;
        } catch (RequestException $e) {
            throw $e;
        }
    }
}
