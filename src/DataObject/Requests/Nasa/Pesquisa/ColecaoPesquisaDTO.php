<?php

namespace App\DataObject\Requests\Nasa\Pesquisa;

use App\API\TradutorAPI;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para a coleção (collection) na resposta da NASA Images API.
 */
class ColecaoPesquisaDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)] private string $version,
        #[Assert\Type(Types::STRING)] private string $href,
        /** @var ItemPesquisaDTO[] */
        private array $items,
        private ?array $metadata = null,
    ) {}

    public static function deArray(array $dados, ?TradutorAPI $tradutor = null): self
    {
        $items = [];
        if (isset($dados['items']) && is_array($dados['items'])) {
            foreach ($dados['items'] as $itemData) {
                $items[] = ItemPesquisaDTO::deArray($itemData, $tradutor);
            }
        }

        return new self(
            version: $dados['version'] ?? '',
            href: $dados['href'] ?? '',
            items: $items,
            metadata: $dados['metadata'] ?? null,
        );
    }

    public function version(): string
    {
        return $this->version;
    }

    public function href(): string
    {
        return $this->href;
    }

    /** @return ItemPesquisaDTO[] */
    public function items(): array
    {
        return $this->items;
    }

    public function metadata(): ?array
    {
        return $this->metadata;
    }

    public function jsonSerialize(): array
    {
        return [
            'version' => $this->version,
            'href' => $this->href,
            'items' => array_map(fn($item) => $item->jsonSerialize(), $this->items),
            'metadata' => $this->metadata,
        ];
    }
}
