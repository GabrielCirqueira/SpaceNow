<?php

namespace App\Controller;

use App\Infra\NasaApiClient;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class NewsController extends AbstractController
{
    #[Route('/news', name: 'news')]
    public function index(NasaApiClient $nasaApiClient): Response
    {
        $response = $nasaApiClient->get(endpoint: "teste/teste");

        return $this->json([
            'message' => 'Welcome to the News page!',
            'status' => 'success'
        ]);
    }
}
