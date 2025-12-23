<?php

namespace App\DataObject\Requests\Nasa;

use App\API\TradutorAPI;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Objeto Próximo à Terra (NEO).
 */
class ObjetoProximoTerraDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)] private ?string $id = null,
        #[Assert\Type(Types::STRING)] private ?string $nome = null,
        #[Assert\Type(Types::STRING)] private ?string $nomePT = null,
        #[Assert\Type(Types::STRING)] private ?string $urlNasaJpl = null,
        #[Assert\Type(Types::BOOLEAN)] private ?bool $potencialmentePerigoso = null,
        private ?array $dadosAproximacao = null,
        private ?array $diametroEstimado = null,
    ) {
    }

    public function obterId(): ?string
    {
        return $this->id;
    }

    public function obterNome(): ?string
    {
        return $this->nome;
    }

    public function obterNomePT(): ?string
    {
        return $this->nomePT;
    }

    public function obterUrlNasaJpl(): ?string
    {
        return $this->urlNasaJpl;
    }

    public function ehPotencialmentePerigoso(): ?bool
    {
        return $this->potencialmentePerigoso;
    }

    public function obterDadosAproximacao(): ?array
    {
        return $this->dadosAproximacao;
    }

    public function obterDiametroEstimado(): ?array
    {
        return $this->diametroEstimado;
    }

    public static function deArray(array $dados, TradutorAPI $tradutor): self
    {
        $nome = $dados['name'] ?? null;
        $nomePT = $nome ? $tradutor->traduzir($nome) : null;

        return new self(
            $dados['id'] ?? null,
            $nome,
            $nomePT,
            $dados['nasa_jpl_url'] ?? null,
            $dados['is_potentially_hazardous_asteroid'] ?? null,
            $dados['close_approach_data'] ?? null,
            $dados['estimated_diameter'] ?? null,
        );
    }

    public function jsonSerialize(): array
    {
        return [
            'id' => $this->id,
            'nome' => $this->nome,
            'nomePT' => $this->nomePT,
            'urlNasaJpl' => $this->urlNasaJpl,
            'potencialmentePerigoso' => $this->potencialmentePerigoso,
            'dadosAproximacao' => $this->dadosAproximacao,
            'diametroEstimado' => $this->diametroEstimado,
        ];
    }
}
