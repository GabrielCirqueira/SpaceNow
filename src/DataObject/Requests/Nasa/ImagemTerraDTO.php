<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Imagem de Satélite da Terra
 */
class ImagemTerraDTO
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private string $data,
        #[Assert\Type(Types::STRING)]
        private string $url,
        #[Assert\Type(Types::STRING)]
        private ?string $pontuacaoNuvens = null,
        #[Assert\Type(Types::STRING)]
        private ?string $id = null,
    ) {
    }

    public function obterData(): string
    {
        return $this->data;
    }

    public function obterUrl(): string
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
        if (!isset($dados['date'], $dados['url'])) {
            throw new \InvalidArgumentException('Campos obrigatórios ausentes ao criar ImagemTerraDTO');
        }

        return new self(
            $dados['date'],
            $dados['url'],
            $dados['cloud_score'] ?? null,
            $dados['id'] ?? null
        );
    }
}
