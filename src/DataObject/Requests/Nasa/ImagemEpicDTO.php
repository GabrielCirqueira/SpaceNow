<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Imagem EPIC (Câmera Policromática da Terra)
 */
class ImagemEpicDTO
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private string $identificador,
        #[Assert\Type(Types::STRING)]
        private string $legenda,
        #[Assert\Type(Types::STRING)]
        private string $imagem,
        #[Assert\Type(Types::STRING)]
        private string $versao,
        #[Assert\Type(Types::STRING)]
        private string $data,
        private array $coordenadasCentroide,
        private array $posicaoDscovrJ2000,
        private array $posicaoLunarJ2000,
        private array $posicaoSolarJ2000,
        private array $quaterniosAtitude,
    ) {
    }

    public function obterIdentificador(): string
    {
        return $this->identificador;
    }

    public function obterLegenda(): string
    {
        return $this->legenda;
    }

    public function obterImagem(): string
    {
        return $this->imagem;
    }

    public function obterVersao(): string
    {
        return $this->versao;
    }

    public function obterData(): string
    {
        return $this->data;
    }

    public function obterCoordenadasCentroide(): array
    {
        return $this->coordenadasCentroide;
    }

    public function obterPosicaoDscovr(): array
    {
        return $this->posicaoDscovrJ2000;
    }

    public function obterPosicaoLunar(): array
    {
        return $this->posicaoLunarJ2000;
    }

    public function obterPosicaoSolar(): array
    {
        return $this->posicaoSolarJ2000;
    }

    public function obterQuaterniosAtitude(): array
    {
        return $this->quaterniosAtitude;
    }

    public static function deArray(array $dados): self
    {
        if (!isset($dados['identifier'], $dados['caption'], $dados['image'], $dados['version'], $dados['date'])) {
            throw new \InvalidArgumentException('Campos obrigatórios ausentes ao criar ImagemEpicDTO');
        }

        return new self(
            $dados['identifier'],
            $dados['caption'],
            $dados['image'],
            $dados['version'],
            $dados['date'],
            $dados['centroid_coordinates'] ?? [],
            $dados['dscovr_j2000_position'] ?? [],
            $dados['lunar_j2000_position'] ?? [],
            $dados['sun_j2000_position'] ?? [],
            $dados['attitude_quaternions'] ?? []
        );
    }
}
