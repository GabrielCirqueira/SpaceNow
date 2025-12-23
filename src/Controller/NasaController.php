<?php

namespace App\Controller;

use App\API\NasaAPI;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

#[Route('/nasa')]
class NasaController extends AbstractController
{
    #[Route(path: '/apodDay', name: 'imagem_astronomica_dia')]
    public function imagemAstronomicaDia(NasaAPI $nasaAPI): Response
    {
        try {
            $DTO = $nasaAPI->imagemAstronomicaDia()->obterUltimos(limit: 1);

            $dados = array_map(callback: fn ($dto): mixed => $dto->jsonSerialize(), array: $DTO);

            return $this->json(data: $dados[0], status: Response::HTTP_OK);
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
            $DTOs = $nasaAPI->imagemAstronomicaDia()->obterPorPeriodo('2020-01-01', '2020-03-01');

            $dados = array_map(callback: fn ($dto): mixed => $dto->jsonSerialize(), array: $DTOs);

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
