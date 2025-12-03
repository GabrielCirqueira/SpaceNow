<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Imagem de Satélite da Terra
 */
class ImagemTerraDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private ?string $data = null,
        #[Assert\Type(Types::STRING)]
        private ?string $url = null,
        #[Assert\Type(Types::STRING)]
        private ?string $pontuacaoNuvens = null,
        #[Assert\Type(Types::STRING)]
        private ?string $id = null,
    ) {}

    public function obterData(): ?string
    {
        return $this->data;
    }

    public function obterUrl(): ?string
    {
        return $this->url;
    }

    public function obterPontuacaoNuvens(): ?string
    {
        return $this->pontuacaoNuvens;
    }

    public function obterId(): ?string
    {
        return $this->id;
    }

    public static function deArray(array $dados): self
    {
        return new self(
            $dados['date'] ?? null,
            $dados['url'] ?? null,
            $dados['cloud_score'] ?? null,
            $dados['id'] ?? null
        );
    }

    public function jsonSerialize(): array
    {
        return [
            'data' => $this->data,
            'url' => $this->url,
            'pontuacaoNuvens' => $this->pontuacaoNuvens,
            'id' => $this->id,
        ];
    }
}
