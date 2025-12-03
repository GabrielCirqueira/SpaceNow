<?php

namespace App\DataObject\Requests\Nasa;

use App\API\TradutorAPI;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Evento DONKI (Clima Espacial)
 */
class EventoDonkiDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)] private ?string $idAtividade = null,
        #[Assert\Type(Types::STRING)] private ?string $horarioInicio = null,
        #[Assert\Type(Types::STRING)] private ?string $horarioPico = null,
        #[Assert\Type(Types::STRING)] private ?string $horarioFim = null,
        #[Assert\Type(Types::STRING)] private ?string $tipoClasse = null,
        #[Assert\Type(Types::STRING)] private ?string $localizacaoOrigem = null,
        #[Assert\Type(Types::STRING)] private ?string $localizacaoOrigemPT = null,
        private ?array $eventosVinculados = null,
    ) {}

    public function obterIdAtividade(): ?string
    {
        return $this->idAtividade;
    }

    public function obterHorarioInicio(): ?string
    {
        return $this->horarioInicio;
    }

    public function obterHorarioPico(): ?string
    {
        return $this->horarioPico;
    }

    public function obterHorarioFim(): ?string
    {
        return $this->horarioFim;
    }

    public function obterTipoClasse(): ?string
    {
        return $this->tipoClasse;
    }

    public function obterLocalizacaoOrigem(): ?string
    {
        return $this->localizacaoOrigem;
    }

    public function obterLocalizacaoOrigemPT(): ?string
    {
        return $this->localizacaoOrigemPT;
    }

    public function obterEventosVinculados(): ?array
    {
        return $this->eventosVinculados;
    }

    public static function deArray(array $dados, TradutorAPI $tradutor): self
    {
        $localizacaoOrigem = $dados['sourceLocation'] ?? null;
        $localizacaoOrigemPT = $localizacaoOrigem ? $tradutor->traduzir($localizacaoOrigem) : null;

        return new self(
            $dados['activityID'] ?? null,
            $dados['startTime'] ?? null,
            $dados['peakTime'] ?? null,
            $dados['endTime'] ?? null,
            $dados['classType'] ?? null,
            $localizacaoOrigem,
            $localizacaoOrigemPT,
            $dados['linkedEvents'] ?? null,
        );
    }

    public function jsonSerialize(): array
    {
        return [
            'idAtividade' => $this->idAtividade,
            'horarioInicio' => $this->horarioInicio,
            'horarioPico' => $this->horarioPico,
            'horarioFim' => $this->horarioFim,
            'tipoClasse' => $this->tipoClasse,
            'localizacaoOrigem' => $this->localizacaoOrigem,
            'localizacaoOrigemPT' => $this->localizacaoOrigemPT,
            'eventosVinculados' => $this->eventosVinculados,
        ];
    }
}
