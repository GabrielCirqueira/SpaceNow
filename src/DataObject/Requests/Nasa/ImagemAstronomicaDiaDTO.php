<?php

namespace App\DataObject\Requests\Nasa;

use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para Imagem Astronômica do Dia (APOD)
 */
class ImagemAstronomicaDiaDTO
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private ?string $direitosAutorais = null,
        #[Assert\Type(Types::STRING)]
        private string $data,
        #[Assert\Type(Types::STRING)]
        private string $explicacao,
        #[Assert\Type(Types::STRING)]
        private ?string $explicacaoPT = null,
        #[Assert\Type(Types::STRING)]
        private string $urlHd,
        #[Assert\Type(Types::STRING)]
        private string $tipoMidia,
        #[Assert\Type(Types::STRING)]
        private string $versaoServico,
        #[Assert\Type(Types::STRING)]
        private string $titulo,
        #[Assert\Type(Types::STRING)]
        private string $url,
    ) {
    }

    public function obterDireitosAutorais(): ?string
    {
        return $this->direitosAutorais;
    }

    public function obterData(): string
    {
        return $this->data;
    }

    public function obterExplicacao(): string
    {
        return $this->explicacao;
    }

    public function obterUrlHd(): string
    {
        return $this->urlHd;
    }

    public function obterTipoMidia(): string
    {
        return $this->tipoMidia;
    }

    public function obterVersaoServico(): string
    {
        return $this->versaoServico;
    }

    public function obterTitulo(): string
    {
        return $this->titulo;
    }

    public function obterUrl(): string
    {
        return $this->url;
    }

    public static function deArray(array $dados): self
    {
        if (!isset($dados['date'], $dados['explanation'], $dados['media_type'], $dados['service_version'], $dados['title'], $dados['url'])) {
            throw new \InvalidArgumentException('Campos obrigatórios ausentes ao criar ImagemAstronomicaDiaDTO');
        }

        $explicacaoPT = null;

        return new self(
            $dados['copyright'] ?? null,
            $dados['date'],
            $dados['explanation'],
            $explicacaoPT,
            $dados['hdurl'] ?? '',
            $dados['media_type'],
            $dados['service_version'],
            $dados['title'],
            $dados['url']
        );
    }
}