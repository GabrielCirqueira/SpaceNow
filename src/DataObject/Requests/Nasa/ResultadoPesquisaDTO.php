<?php

namespace App\DataObject\Requests\Nasa;

use App\API\TradutorAPI;
use App\DataObject\Requests\Nasa\Pesquisa\ColecaoPesquisaDTO;
use JsonSerializable;

/**
 * DTO raiz para a resposta completa da NASA Images API
 */
class ResultadoPesquisaDTO implements JsonSerializable
{
    public function __construct(
        private ColecaoPesquisaDTO $collection,
    ) {}

    public static function deArray(array $dados, ?TradutorAPI $tradutor = null): self
    {
        $collection = ColecaoPesquisaDTO::deArray($dados['collection'] ?? [], $tradutor);

        return new self(
            collection: $collection,
        );
    }

    public function collection(): ColecaoPesquisaDTO
    {
        return $this->collection;
    }

    public function jsonSerialize(): array
    {
        return [
            'collection' => $this->collection->jsonSerialize(),
        ];
    }
}
