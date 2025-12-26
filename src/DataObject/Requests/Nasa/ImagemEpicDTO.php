<?php

namespace App\DataObject\Requests\Nasa;

use App\API\TradutorAPI;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Imagem EPIC (Câmera Policromática da Terra).
 */
class ImagemEpicDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)] private ?string $identificador = null,
        #[Assert\Type(Types::STRING)] private ?string $legenda = null,
        #[Assert\Type(Types::STRING)] private ?string $legendaPT = null,
        #[Assert\Type(Types::STRING)] private ?string $imagem = null,
        #[Assert\Type(Types::STRING)] private ?string $versao = null,
        #[Assert\Type(Types::STRING)] private ?string $data = null,
        private ?array $coordenadasCentroide = null,
        private ?array $posicaoDscovrJ2000 = null,
        private ?array $posicaoLunarJ2000 = null,
        private ?array $posicaoSolarJ2000 = null,
        private ?array $quaterniosAtitude = null,
    ) {
    }

    public function obterIdentificador(): ?string
    {
        return $this->identificador;
    }

    public function obterLegenda(): ?string
    {
        return $this->legenda;
    }

    public function obterLegendaPT(): ?string
    {
        return $this->legendaPT;
    }

    public function obterImagem(): ?string
    {
        return $this->imagem;
    }

    public function obterVersao(): ?string
    {
        return $this->versao;
    }

    public function obterData(): ?string
    {
        return $this->data;
    }

    public function obterCoordenadasCentroide(): ?array
    {
        return $this->coordenadasCentroide;
    }

    public function obterPosicaoDscovr(): ?array
    {
        return $this->posicaoDscovrJ2000;
    }

    public function obterPosicaoLunar(): ?array
    {
        return $this->posicaoLunarJ2000;
    }

    public function obterPosicaoSolar(): ?array
    {
        return $this->posicaoSolarJ2000;
    }

    public function obterQuaterniosAtitude(): ?array
    {
        return $this->quaterniosAtitude;
    }

    public static function deArray(array $dados, TradutorAPI $tradutor): self
    {
        $legenda = $dados['caption'] ?? null;
        $legendaPT = $legenda ? $tradutor->traduzir($legenda) : null;

        return new self(
            $dados['identifier'] ?? null,
            $legenda,
            $legendaPT,
            $dados['image'] ?? null,
            $dados['version'] ?? null,
            $dados['date'] ?? null,
            $dados['centroid_coordinates'] ?? null,
            $dados['dscovr_j2000_position'] ?? null,
            $dados['lunar_j2000_position'] ?? null,
            $dados['sun_j2000_position'] ?? null,
            $dados['attitude_quaternions'] ?? null,
        );
    }

    public function jsonSerialize(): array
    {
        return [
            'identificador' => $this->identificador,
            'legenda' => $this->legenda,
            'legendaPT' => $this->legendaPT,
            'imagem' => $this->imagem,
            'versao' => $this->versao,
            'data' => $this->data,
            'coordenadasCentroide' => $this->coordenadasCentroide,
            'posicaoDscovrJ2000' => $this->posicaoDscovrJ2000,
            'posicaoLunarJ2000' => $this->posicaoLunarJ2000,
            'posicaoSolarJ2000' => $this->posicaoSolarJ2000,
            'quaterniosAtitude' => $this->quaterniosAtitude,
        ];
    }
}
