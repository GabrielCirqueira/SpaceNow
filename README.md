# SpaceNow — Portal de Notícias da NASA

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![PHP](https://img.shields.io/badge/PHP-8.4-777BB4?logo=php)
![Symfony](https://img.shields.io/badge/Symfony-7.3-000000?logo=symfony)
![React](https://img.shields.io/badge/React-19-61DAFB?logo=react)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6?logo=typescript)

Portal de notícias sobre o espaço, astronomia e missões da NASA. Desenvolvido com Symfony 7 + React 19 + Vite.

## 🚀 Recursos

- **Frontend Moderno**: React 19 com TypeScript e Vite para desenvolvimento ágil
- **Backend Robusto**: Symfony 7.3 com PHP 8.4
- **Design Responsivo**: Interface adaptável para todos os dispositivos
- **Tema Dark/Light**: Alternância entre temas claro e escuro
- **API da NASA**: Integração com APIs oficiais da NASA

## 📋 Pré-requisitos

- Docker e Docker Compose
- Node.js 20+ e npm
- Make (opcional, para comandos facilitados)

## 🛠️ Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/GabrielCirqueira/SpaceNow.git
cd SpaceNow
```

### 2. Inicie os containers Docker

```bash
make up-d
# ou
docker-compose up -d
```

### 3. Instale as dependências

```bash
make install
# ou
docker-compose exec symfony composer install
npm install
```

### 4. Configure o banco de dados

```bash
make db-create
make db-migrate
# ou
docker-compose exec symfony php bin/console doctrine:database:create
docker-compose exec symfony php bin/console doctrine:migrations:migrate
```

### 5. Inicie o servidor de desenvolvimento

```bash
npm run dev
```

Acesse: \`http://localhost:5173\`

## 🔧 Comandos Úteis

| Comando | Descrição |
|---------|-----------|
| \`make up-d\` | Inicia containers em background |
| \`make down\` | Para os containers |
| \`make install\` | Instala todas as dependências |
| \`make db-create\` | Cria o banco de dados |
| \`make db-migrate\` | Executa as migrations |
| \`npm run dev\` | Inicia o servidor de desenvolvimento |
| \`npm run build\` | Build de produção |
| \`npm run lint\` | Verifica código com ESLint |

## 📦 Estrutura do Projeto

\`\`\`
SpaceNow/
├── assets/           # Assets do Symfony
├── bin/             # Scripts executáveis
├── config/          # Configurações do Symfony
├── migrations/      # Migrations do banco de dados
├── public/          # Arquivos públicos
├── src/             # Código-fonte PHP
│   ├── Controller/  # Controllers
│   ├── Entity/      # Entidades Doctrine
│   └── Repository/  # Repositories
├── templates/       # Templates Twig
├── web/            # Aplicação React
│   ├── components/  # Componentes React
│   ├── pages/       # Páginas da aplicação
│   ├── layouts/     # Layouts
│   └── themes/      # Configuração de temas
└── docker/         # Configurações Docker
\`\`\`

## 🌐 Tecnologias

### Backend
- **Symfony 7.3**: Framework PHP moderno
- **PHP 8.4**: Última versão do PHP
- **Doctrine ORM**: Mapeamento objeto-relacional
- **MySQL 8.3**: Banco de dados

### Frontend
- **React 19**: Biblioteca JavaScript moderna
- **TypeScript**: Superset tipado do JavaScript
- **Vite 7**: Build tool ultrarrápido
- **Tailwind CSS**: Framework CSS utility-first
- **shadcn/ui**: Componentes de UI reutilizáveis

### DevOps
- **Docker**: Containerização
- **Docker Compose**: Orquestração de containers
- **Nginx/Apache**: Servidor web

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## 📄 Licença

Este projeto é proprietário.

## 👨‍💻 Autor

**Gabriel Cirqueira**

---

⭐ **SpaceNow** - Seu portal de notícias do espaço
