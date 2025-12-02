<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Foto do Rover de Marte
 */
class FotoRoverMarteDTO
{
    public function __construct(
        #[Assert\Type(Types::INTEGER)]
        private int $id,
        #[Assert\Type(Types::INTEGER)]
        private int $sol,
        #[Assert\Type(Types::STRING)]
        private string $urlImagem,
        #[Assert\Type(Types::STRING)]
        private string $dataTerra,
        private array $camera,
        private array $rover,
    ) {
    }

    public function obterId(): int
    {
        return $this->id;
    }

    public function obterSol(): int
    {
        return $this->sol;
    }

    public function obterUrlImagem(): string
    {
        return $this->urlImagem;
    }

    public function obterDataTerra(): string
    {
        return $this->dataTerra;
    }

    public function obterCamera(): array
    {
        return $this->camera;
    }

    public function obterRover(): array
    {
        return $this->rover;
    }

    public static function deArray(array $dados): self
    {
        if (!isset($dados['id'], $dados['sol'], $dados['img_src'], $dados['earth_date'], $dados['camera'], $dados['rover'])) {
            throw new \InvalidArgumentException('Campos obrigatórios ausentes ao criar FotoRoverMarteDTO');
        }

        return new self(
            $dados['id'],
            $dados['sol'],
            $dados['img_src'],
            $dados['earth_date'],
            $dados['camera'],
            $dados['rover']
        );
    }
}
