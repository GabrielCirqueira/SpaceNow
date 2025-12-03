<?php

namespace App\API;

use App\API\Nasa\ImagemAstronomicaDiaAPI;
use App\API\Nasa\ObjetoProximoTerraAPI;
use App\API\Nasa\ImagemTerraAPI;
use App\API\Nasa\CameraEpicAPI;
use App\API\Nasa\ClimaEspacialAPI;
use App\API\PesquisaAPI;

/**
 * Facade/Agregador para todas as APIs da NASA
 * Delega as chamadas para as classes especializadas organizadas por categoria
 */
class NasaAPI
{
    public function __construct(
        private ImagemAstronomicaDiaAPI $imagemAstronomicaDiaAPI,
        private ObjetoProximoTerraAPI $objetoProximoTerraAPI,
        private ImagemTerraAPI $imagemTerraAPI,
        private CameraEpicAPI $cameraEpicAPI,
        private ClimaEspacialAPI $climaEspacialAPI,
        private PesquisaAPI $pesquisaAPI
    ) {}

    public function imagemAstronomicaDia(): ImagemAstronomicaDiaAPI
    {
        return $this->imagemAstronomicaDiaAPI;
    }

    public function objetoProximoTerra(): ObjetoProximoTerraAPI
    {
        return $this->objetoProximoTerraAPI;
    }

    public function imagemTerra(): ImagemTerraAPI
    {
        return $this->imagemTerraAPI;
    }

    public function cameraEpic(): CameraEpicAPI
    {
        return $this->cameraEpicAPI;
    }

    public function climaEspacial(): ClimaEspacialAPI
    {
        return $this->climaEspacialAPI;
    }

    public function pesquisa(): PesquisaAPI
    {
        return $this->pesquisaAPI;
    }
}
