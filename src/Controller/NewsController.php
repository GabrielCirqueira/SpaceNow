<?php

namespace App\Controller;

use App\API\NasaAPI;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class NewsController extends AbstractController
{
    #[Route('/news', name: 'news')]
    public function index(NasaAPI $nasaAPI): Response
    {
        $DTOs = $nasaAPI->objetoProximoTerra()->obterFeed('2025-11-01', '2025-11-07');
        dd($DTOs);
        $dados = array_map(fn($dto) => $dto->jsonSerialize(), $DTOs);

        return $this->json([
            'dados' => $dados,
            'status' => 'success'
        ]);
    }
}
