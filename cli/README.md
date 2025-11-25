# 🛠️ CLI Utilities - SpaceNow

Coleção de scripts utilitários para acelerar o desenvolvimento.

## 📋 Scripts Disponíveis

### 🎨 Criação de Código

#### `create-component.sh`

Cria um novo componente React com estrutura completa.

```bash
./cli/create-component.sh <ComponentName> [path]

# Exemplos
./cli/create-component.sh Button
./cli/create-component.sh Card src/components/ui
./cli/create-component.sh UserProfile src/features/user/components
```

**Gera:**

- `ComponentName.tsx` - Componente com TypeScript e forwardRef
- `types.ts` - Tipos e interfaces
- `index.ts` - Exportações
- `ComponentName.test.tsx` - Testes com Vitest
- `README.md` - Documentação do componente

---

#### `create-page.sh`

Cria uma nova página com integração ao React Router.

```bash
./cli/create-page.sh <PageName> [route]

# Exemplos
./cli/create-page.sh About
./cli/create-page.sh UserProfile /profile
./cli/create-page.sh ContactUs /contact
```

**Gera:**

- `PageName.tsx` - Página com AppContainer e layout
- `index.ts` - Exportações
- `README.md` - Documentação com instruções de rota

---

#### `create-hook.sh`

Cria um custom hook React com TypeScript.

```bash
./cli/create-hook.sh <hookName>

# Exemplos
./cli/create-hook.sh useLocalStorage
./cli/create-hook.sh useDebounce
./cli/create-hook.sh useFetch
```

**Gera:**

- `hookName.ts` - Hook com TypeScript
- `hookName.test.ts` - Testes com renderHook
- Atualiza `src/hooks/index.ts` automaticamente

---

### 📊 Análise e Estatísticas

#### `analyze-bundle.sh`

Analisa o tamanho do bundle de produção.

```bash
./cli/analyze-bundle.sh
```

**Mostra:**

- Tamanho de todos os arquivos JS e CSS
- Tamanho total do bundle
- Arquivos grandes (> 500KB)
- Estatísticas e dicas de otimização

---

#### `check-deps.sh`

Verifica dependências e vulnerabilidades.

```bash
./cli/check-deps.sh [--fix]

# Modo visualização (padrão)
./cli/check-deps.sh

# Modo correção automática
./cli/check-deps.sh --fix
```

**Verifica:**

- ✅ Dependências desatualizadas
- 🔒 Vulnerabilidades de segurança
- 🔄 Pacotes duplicados
- 📊 Tamanho das dependências
- 🏋️ Top 10 maiores pacotes

**Modo --fix:**

- Atualiza dependências
- Corrige vulnerabilidades
- Remove duplicatas

---

#### `git-stats.sh`

Exibe estatísticas detalhadas do repositório Git.

```bash
./cli/git-stats.sh
```

**Exibe:**

- 📁 Branch atual e remote
- 📝 Contagem de commits (total, hoje, semana, mês)
- 👥 Top contribuidores
- 🔥 Arquivos mais modificados
- 📈 Linhas adicionadas/removidas
- ⏰ Últimos commits
- 📋 Status atual
- 🌿 Branches e tags
- 💾 Tamanho do repositório

---

### 🎨 Recursos

#### `generate-icons.sh`

Gera referência de ícones Lucide React.

```bash
./cli/generate-icons.sh [search_term]

# Gerar referência completa
./cli/generate-icons.sh

# Buscar ícones específicos
./cli/generate-icons.sh user
./cli/generate-icons.sh arrow
```

**Gera:**

- `ICONS_REFERENCE.md` - Documentação completa de ícones
- Lista categorizada por função
- Exemplos de código
- Links úteis

---

## 🚀 Quick Start

### 1. Tornar scripts executáveis

```bash
chmod +x cli/*.sh
```

### 2. Usar os scripts

```bash
# Criar um componente
./cli/create-component.sh MyButton

# Criar uma página
./cli/create-page.sh Dashboard /dashboard

# Criar um hook
./cli/create-hook.sh useAuth

# Analisar bundle
./cli/analyze-bundle.sh

# Verificar dependências
./cli/check-deps.sh

# Ver estatísticas Git
./cli/git-stats.sh

# Gerar referência de ícones
./cli/generate-icons.sh
```

---

## 📚 Estrutura de Arquivos Gerados

### Componente

```
src/components/Button/
├── Button.tsx              # Componente
├── types.ts                # Tipos
├── index.ts                # Exportações
├── Button.test.tsx         # Testes
└── README.md               # Documentação
```

### Página

```
src/pages/Dashboard/
├── Dashboard.tsx           # Página
├── index.ts                # Exportações
└── README.md               # Documentação + instruções de rota
```

### Hook

```
src/hooks/
├── useAuth.ts              # Hook
├── useAuth.test.ts         # Testes
└── index.ts                # Exportações (atualizado)
```

---

## 💡 Dicas de Uso

### 1. Aliases e Atalhos

Adicione ao seu `.bashrc` ou `.zshrc`:

```bash
alias new-component='./cli/create-component.sh'
alias new-page='./cli/create-page.sh'
alias new-hook='./cli/create-hook.sh'
alias check-bundle='./cli/analyze-bundle.sh'
alias check-deps='./cli/check-deps.sh'
alias git-stats='./cli/git-stats.sh'
```

### 2. Integração com Makefile

Os scripts já estão integrados no Makefile:

```bash
make component NAME=Button
make page NAME=Dashboard
make check-deps
make git-stats
```

### 3. Workflow Recomendado

**Ao criar novo componente:**

```bash
# 1. Criar estrutura
./cli/create-component.sh MyComponent

# 2. Implementar
code src/components/MyComponent/MyComponent.tsx

# 3. Testar
npm run test MyComponent

# 4. Validar
make validate
```

**Ao criar nova página:**

```bash
# 1. Criar estrutura
./cli/create-page.sh Dashboard /dashboard

# 2. Adicionar rota em App.tsx
# (instruções no README.md gerado)

# 3. Implementar
code src/pages/Dashboard/Dashboard.tsx

# 4. Testar navegação
npm run dev
```

---

## 🔧 Personalização

### Modificar Templates

Edite os scripts para personalizar os templates gerados:

```bash
# Editar template de componente
nano cli/create-component.sh

# Editar template de página
nano cli/create-page.sh

# Editar template de hook
nano cli/create-hook.sh
```

### Adicionar Novos Scripts

Crie novos scripts seguindo o padrão:

```bash
#!/bin/bash
set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Sua lógica aqui
echo -e "${GREEN}✅ Sucesso!${NC}"
```

---

## 📖 Documentação Adicional

- **Convenções de Código**: Ver `DEVELOPMENT.md`
- **Setup do Projeto**: Ver `SETUP.md`
- **Makefile Commands**: Run `make help`
- **Ícones Disponíveis**: Execute `./cli/generate-icons.sh`

---

## 🤝 Contribuindo

Para adicionar novos scripts:

1. Crie o script em `cli/`
2. Torne-o executável: `chmod +x cli/seu-script.sh`
3. Adicione documentação neste README
4. (Opcional) Integre com o Makefile
5. Commit com mensagem descritiva

---

## 📝 Notas

- **Permissões**: Scripts precisam ser executáveis (`chmod +x`)
- **Bash**: Requer Bash 4.0+
- **Git**: Scripts Git requerem repositório inicializado
- **Node.js**: Scripts de análise requerem Node.js instalado
- **Cores**: Se as cores não funcionarem, verifique suporte ANSI do terminal

---

**Criado com ❤️ para acelerar o desenvolvimento**
