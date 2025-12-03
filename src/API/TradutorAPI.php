<?php

namespace App\API;

use GuzzleHttp\Client;
use Stichoza\GoogleTranslate\GoogleTranslate;

class TradutorAPI
{
    public function __construct(private GoogleTranslate $tradutor) {}

    public function traduzir(string $texto): string
    {
        return $this->tradutor->translate($texto);
    }
}
