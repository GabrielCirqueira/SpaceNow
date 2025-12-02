<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Evento DONKI (Clima Espacial)
 */
class EventoDonkiDTO
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private string $idAtividade,
        #[Assert\Type(Types::STRING)]
        private string $horarioInicio,
        #[Assert\Type(Types::STRING)]
        private ?string $horarioPico = null,
        #[Assert\Type(Types::STRING)]
        private ?string $horarioFim = null,
        #[Assert\Type(Types::STRING)]
        private ?string $tipoClasse = null,
        #[Assert\Type(Types::STRING)]
        private ?string $localizacaoOrigem = null,
        private array $eventosVinculados = [],
    ) {
    }

    public function obterIdAtividade(): string
    {
        return $this->idAtividade;
    }

    public function obterHorarioInicio(): string
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

    public function obterEventosVinculados(): array
    {
        return $this->eventosVinculados;
    }

    public static function deArray(array $dados): self
    {
        if (!isset($dados['activityID'], $dados['startTime'])) {
            throw new \InvalidArgumentException('Campos obrigatórios ausentes ao criar EventoDonkiDTO');
        }

        return new self(
            $dados['activityID'],
            $dados['startTime'],
            $dados['peakTime'] ?? null,
            $dados['endTime'] ?? null,
            $dados['classType'] ?? null,
            $dados['sourceLocation'] ?? null,
            $dados['linkedEvents'] ?? []
        );
    }
}