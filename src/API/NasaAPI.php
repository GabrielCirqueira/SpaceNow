<?php

namespace App\API;

use App\Infra\NasaApiClient;
use GuzzleHttp\Client;

class NasaAPI extends NasaApiClient
{
    public function __construct(Client $clientGuzzle, string $nasaApiKey)
    {
        parent::__construct($clientGuzzle, $nasaApiKey);
    }
}
