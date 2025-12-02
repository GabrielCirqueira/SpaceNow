<?php

namespace App\DataObject\Requests\Nasa;

use App\API\TradutorAPI;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Imagem Astronômica do Dia (APOD)
 */
class ImagemAstronomicaDiaDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private ?string $direitosAutorais = null,
        #[Assert\Type(Types::STRING)]
        private ?string $data = null,
        #[Assert\Type(Types::STRING)]
        private ?string $explicacao = null,
        #[Assert\Type(Types::STRING)]
        private ?string $explicacaoPT = null,
        #[Assert\Type(Types::STRING)]
        private ?string $urlHd = null,
        #[Assert\Type(Types::STRING)]
        private ?string $tipoMidia = null,
        #[Assert\Type(Types::STRING)]
        private ?string $versaoServico = null,
        #[Assert\Type(Types::STRING)]
        private ?string $titulo = null,
        #[Assert\Type(Types::STRING)]
        private ?string $tituloPT = null,
        #[Assert\Type(Types::STRING)]
        private ?string $url = null,
    ) {
    }

    public function obterDireitosAutorais(): ?string
    {
        return $this->direitosAutorais;
    }

    public function obterData(): ?string
    {
        return $this->data;
    }

    public function obterExplicacao(): ?string
    {
        return $this->explicacao;
    }

    public function obterUrlHd(): ?string
    {
        return $this->urlHd;
    }

    public function obterTipoMidia(): ?string
    {
        return $this->tipoMidia;
    }

    public function obterVersaoServico(): ?string
    {
        return $this->versaoServico;
    }

    public function obterTitulo(): ?string
    {
        return $this->titulo;
    }

    public function obterUrl(): ?string
    {
        return $this->url;
    }

    public function explicacaoPT(): ?string
    {
        return $this->explicacaoPT;
    }

    public function tituloPT(): ?string
    {
        return $this->tituloPT;
    }

    public static function deArray(array $dados, TradutorAPI $tradutor): self
    {
        $explicacaoPT = null;
        if (isset($dados['explanation']) && $dados['explanation']) {
            $explicacaoPT = $tradutor->traduzir(texto: $dados['explanation']);
        }

        $tituloPT = null;
        if (isset($dados['title']) && $dados['title']) {
            $tituloPT = $tradutor->traduzir(texto: $dados['title']);
        }

        return new self(
            direitosAutorais: $dados['copyright'] ?? null,
            data: $dados['date'] ?? null,
            explicacao: $dados['explanation'] ?? null,
            explicacaoPT: $explicacaoPT,
            urlHd: $dados['hdurl'] ?? null,
            tipoMidia: $dados['media_type'] ?? null,
            versaoServico: $dados['service_version'] ?? null,
            titulo: $dados['title'] ?? null,
            tituloPT: $tituloPT,
            url: $dados['url'] ?? null,
        );
    }

    public function jsonSerialize(): array
    {
        return [
            'direitosAutorais' => $this->direitosAutorais,
            'data' => $this->data,
            'explicacao' => $this->explicacao,
            'explicacaoPT' => $this->explicacaoPT,
            'urlHd' => $this->urlHd,
            'tipoMidia' => $this->tipoMidia,
            'versaoServico' => $this->versaoServico,
            'titulo' => $this->titulo,
            'tituloPT' => $this->tituloPT,
            'url' => $this->url,
        ];
    }
}
