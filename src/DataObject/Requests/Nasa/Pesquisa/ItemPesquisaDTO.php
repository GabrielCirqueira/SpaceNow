<?php

namespace App\DataObject\Requests\Nasa\Pesquisa;

use App\API\TradutorAPI;
use Doctrine\DBAL\Types\Types;
use Symfony\Component\Validator\Constraints as Assert;

/**
 * DTO para item individual na resposta da NASA Images API
 * Cada item contém um array de dados (data) e um array de links (links).
 */
class ItemPesquisaDTO implements \JsonSerializable
{
    public function __construct(
        #[Assert\Type(Types::STRING)] private string $href,
        /** @var DadosPesquisaDTO[] */
        private array $data,
        /** @var LinkPesquisaDTO[] */
        private array $links,
    ) {
    }

    public static function deArray(array $dados, ?TradutorAPI $tradutor = null): self
    {
        $data = [];
        if (isset($dados['data']) && is_array($dados['data'])) {
            foreach ($dados['data'] as $itemData) {
                $data[] = DadosPesquisaDTO::deArray($itemData, $tradutor);
            }
        }

        $links = [];
        if (isset($dados['links']) && is_array($dados['links'])) {
            foreach ($dados['links'] as $linkData) {
                $links[] = LinkPesquisaDTO::deArray($linkData);
            }
        }

        return new self(href: $dados['href'] ?? '', data: $data, links: $links);
    }

    public function href(): string
    {
        return $this->href;
    }

    /** @return DadosPesquisaDTO[] */
    public function data(): array
    {
        return $this->data;
    }

    /** @return LinkPesquisaDTO[] */
    public function links(): array
    {
        return $this->links;
    }

    public function jsonSerialize(): array
    {
        return [
            'href' => $this->href,
            'data' => array_map(fn ($d) => $d->jsonSerialize(), $this->data),
            'links' => array_map(fn ($l) => $l->jsonSerialize(), $this->links),
        ];
    }
}
