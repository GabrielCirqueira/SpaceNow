<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Objeto Próximo à Terra (NEO)
 */
class ObjetoProximoTerraDTO
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private string $id,
        #[Assert\Type(Types::STRING)]
        private string $nome,
        #[Assert\Type(Types::STRING)]
        private string $urlNasaJpl,
        #[Assert\Type(Types::BOOLEAN)]
        private bool $potencialmentePerigoso,
        private array $dadosAproximacao,
        private array $diametroEstimado,
    ) {
    }

    public function obterId(): string
    {
        return $this->id;
    }

    public function obterNome(): string
    {
        return $this->nome;
    }

    public function obterUrlNasaJpl(): string
    {
        return $this->urlNasaJpl;
    }

    public function ehPotencialmentePerigoso(): bool
    {
        return $this->potencialmentePerigoso;
    }

    public function obterDadosAproximacao(): array
    {
        return $this->dadosAproximacao;
    }

    public function obterDiametroEstimado(): array
    {
        return $this->diametroEstimado;
    }

    public static function deArray(array $dados): self
    {
        if (!isset($dados['id'], $dados['name'], $dados['nasa_jpl_url'], $dados['is_potentially_hazardous_asteroid'])) {
            throw new \InvalidArgumentException('Campos obrigatórios ausentes ao criar ObjetoProximoTerraDTO');
        }

        return new self(
            $dados['id'],
            $dados['name'],
            $dados['nasa_jpl_url'],
            $dados['is_potentially_hazardous_asteroid'],
            $dados['close_approach_data'] ?? [],
            $dados['estimated_diameter'] ?? []
        );
    }
}
