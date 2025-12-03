<?php

namespace App\DataObject\Requests\Nasa\Pesquisa;

use App\API\TradutorAPI;
use JsonSerializable;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para dados (metadata) de mídia na resposta da NASA Images API
 */
class DadosPesquisaDTO implements JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)]
        private string $nasaId,
        #[Assert\Type(Types::STRING)]
        private string $title,
        #[Assert\Type(Types::STRING)]
        private string $description,
        #[Assert\Type(Types::STRING)]
        private string $mediaType,
        #[Assert\Type(Types::STRING)]
        private string $dateCreated,
        #[Assert\Type(Types::STRING)]
        private ?string $center = null,
        #[Assert\Type(Types::STRING)]
        private ?string $photographer = null,
        #[Assert\Type(Types::STRING)]
        private ?string $secondaryCreator = null,
        #[Assert\Type(Types::STRING)]
        private ?string $description508 = null,
        /** @var string[]|null */
        private ?array $keywords = null,
        /** @var string[]|null */
        private ?array $album = null,
        // Campos traduzidos
        #[Assert\Type(Types::STRING)]
        private ?string $titlePT = null,
        #[Assert\Type(Types::STRING)]
        private ?string $descriptionPT = null,
    ) {}

    public static function deArray(array $dados, ?TradutorAPI $tradutor = null): self
    {
        $title = $dados['title'] ?? '';
        $description = $dados['description'] ?? '';

        $titlePT = null;
        $descriptionPT = null;

        if ($tradutor !== null && !empty($title)) {
            $titlePT = $tradutor->traduzir($title);
        }

        if ($tradutor !== null && !empty($description)) {
            $descriptionPT = $tradutor->traduzir($description);
        }

        return new self(
            nasaId: $dados['nasa_id'] ?? '',
            title: $title,
            description: $description,
            mediaType: $dados['media_type'] ?? '',
            dateCreated: $dados['date_created'] ?? '',
            center: $dados['center'] ?? null,
            photographer: $dados['photographer'] ?? null,
            secondaryCreator: $dados['secondary_creator'] ?? null,
            description508: $dados['description_508'] ?? null,
            keywords: $dados['keywords'] ?? null,
            album: $dados['album'] ?? null,
            titlePT: $titlePT,
            descriptionPT: $descriptionPT,
        );
    }

    public function nasaId(): string
    {
        return $this->nasaId;
    }

    public function title(): string
    {
        return $this->title;
    }

    public function description(): string
    {
        return $this->description;
    }

    public function mediaType(): string
    {
        return $this->mediaType;
    }

    public function dateCreated(): string
    {
        return $this->dateCreated;
    }

    public function center(): ?string
    {
        return $this->center;
    }

    public function photographer(): ?string
    {
        return $this->photographer;
    }

    public function secondaryCreator(): ?string
    {
        return $this->secondaryCreator;
    }

    public function description508(): ?string
    {
        return $this->description508;
    }

    /** @return string[]|null */
    public function keywords(): ?array
    {
        return $this->keywords;
    }

    /** @return string[]|null */
    public function album(): ?array
    {
        return $this->album;
    }

    public function titlePT(): ?string
    {
        return $this->titlePT;
    }

    public function descriptionPT(): ?string
    {
        return $this->descriptionPT;
    }

    public function jsonSerialize(): array
    {
        return [
            'nasa_id' => $this->nasaId,
            'title' => $this->title,
            'title_pt' => $this->titlePT,
            'description' => $this->description,
            'description_pt' => $this->descriptionPT,
            'media_type' => $this->mediaType,
            'date_created' => $this->dateCreated,
            'center' => $this->center,
            'photographer' => $this->photographer,
            'secondary_creator' => $this->secondaryCreator,
            'description_508' => $this->description508,
            'keywords' => $this->keywords,
            'album' => $this->album,
        ];
    }
}
