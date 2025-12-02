<?php

namespace App\Controller;

use App\API\NasaAPI;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class NewsController extends AbstractController
{
    #[Route(path: '/news', name: 'news')]
    public function index(NasaAPI $nasaAPI): Response
    {
        $DTOs = $nasaAPI->imagemAstronomicaDia()->obterPorPeriodo(
            dataInicio: '2024-06-01',
            dataFim: '2024-06-05'
        );

        $dados = array_map(callback: fn($dto): mixed =>
            $dto->jsonSerialize(), array: $DTOs);

        return $this->json(data: [
            'dados' => $dados,
            'status' => 'success'
        ]);
    }
}
