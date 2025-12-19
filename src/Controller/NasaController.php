<?php

namespace App\Controller;

use App\API\NasaAPI;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/nasa')]
class NasaController extends AbstractController
{
    #[Route(path: '/imagemAstronomicaDia', name: 'imagem_astronomica_dia')]
    public function imagemAstronomicaDia(NasaAPI $nasaAPI): Response
    {
        try {
            $DTOs = $nasaAPI
                ->imagemAstronomicaDia()
                ->obterPorPeriodo(dataInicio: '2024-06-01', dataFim: '2024-06-05');

            $dados = array_map(callback: fn($dto): mixed => $dto->jsonSerialize(), array: $DTOs);

            return $this->json(
                data: ['dados' => $dados, 'status' => 'success'],
                status: Response::HTTP_OK,
            );
        } catch (\Exception $e) {
            return $this->json(
                data: ['mensagem' => $e->getMessage(), 'status' => 'error'],
                status: Response::HTTP_INTERNAL_SERVER_ERROR,
            );
        }
    }

    #[Route(path: '/apod', name: 'apod')]
    public function apod(NasaAPI $nasaAPI): Response
    {
        try {
            $DTOs = $nasaAPI->imagemAstronomicaDia()->obterUltimos(limit: 20);

            $dados = array_map(callback: fn($dto): mixed => $dto->jsonSerialize(), array: $DTOs);

            return $this->json(
                data: ['dados' => $dados, 'status' => 'success'],
                status: Response::HTTP_OK,
            );
        } catch (\Exception $e) {
            return $this->json(
                data: ['mensagem' => $e->getMessage(), 'status' => 'error'],
                status: Response::HTTP_INTERNAL_SERVER_ERROR,
            );
        }
    }

    #[Route(path: '/test', name: 'black_hole')]
    public function blackHole(NasaAPI $nasaAPI): Response
    {
        try {
            $DTOs = $nasaAPI->cameraEpic()->obterImagensRealcadas();

            // $dados = array_map(
            //     callback: fn($dto): mixed => $dto->jsonSerialize(),
            //     array: $DTOs->collection()->items(),
            // );

            return $this->json(
                data: ['dados' => $DTOs, 'status' => 'success'],
                status: Response::HTTP_OK,
            );
        } catch (\Exception $e) {
            return $this->json(
                data: ['mensagem' => $e->getMessage(), 'status' => 'error'],
                status: Response::HTTP_INTERNAL_SERVER_ERROR,
            );
        }
    }
}