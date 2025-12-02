<?php

namespace App\Controller;

use App\API\NasaAPI;
use App\Infra\NasaApiClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class NewsController extends AbstractController
{
    #[Route('/news', name: 'news')]
    public function index(NasaAPI $nasaAPI): Response
    {
        $response = $nasaAPI->obterApodPorData('2024-01-01', '2024-01-10');

        dd($response);
        return $this->json([
            'message' => 'Welcome to the News page!',
            'status' => 'success'
        ]);
    }
}