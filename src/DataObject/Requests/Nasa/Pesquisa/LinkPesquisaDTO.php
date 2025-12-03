<?php

namespace App\DataObject\Requests\Nasa\Pesquisa;

use JsonSerializable;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para links de mídia (imagem/vídeo/áudio) na resposta da NASA Images API
 */
class LinkPesquisaDTO implements JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private string $href,
        #[Assert\Type(Types::STRING)]
        private string $rel,
        #[Assert\Type(Types::STRING)]
        private string $render,
        #[Assert\Type(Types::INTEGER)]
        private ?int $width = null,
        #[Assert\Type(Types::INTEGER)]
        private ?int $height = null,
        #[Assert\Type(Types::INTEGER)]
        private ?int $size = null,
    ) {}

    public static function deArray(array $dados): self
    {
        return new self(
            href: $dados['href'] ?? '',
            rel: $dados['rel'] ?? '',
            render: $dados['render'] ?? '',
            width: $dados['width'] ?? null,
            height: $dados['height'] ?? null,
            size: $dados['size'] ?? null,
        );
    }

    public function href(): string
    {
        return $this->href;
    }

    public function rel(): string
    {
        return $this->rel;
    }

    public function render(): string
    {
        return $this->render;
    }

    public function width(): ?int
    {
        return $this->width;
    }

    public function height(): ?int
    {
        return $this->height;
    }

    public function size(): ?int
    {
        return $this->size;
    }

    public function jsonSerialize(): array
    {
        return [
            'href' => $this->href,
            'rel' => $this->rel,
            'render' => $this->render,
            'width' => $this->width,
            'height' => $this->height,
            'size' => $this->size,
        ];
    }
}
