#!/bin/bash

# =============================================================================
# Script: health-check.sh
# Descrição: Verifica a saúde geral do projeto
# Uso: ./cli/health-check.sh
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0
SUCCESS=0

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🏥 Health Check - SpaceNow${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# ==============================================================================
# 1. Node.js e NPM
# ==============================================================================
echo -e "${CYAN}1️⃣  Verificando Node.js e NPM...${NC}"
if command -v node &> /dev/null; then
  NODE_VERSION=$(node --version)
  echo -e "  ${GREEN}✅ Node.js instalado: $NODE_VERSION${NC}"
  ((SUCCESS++))
else
  echo -e "  ${RED}❌ Node.js não encontrado${NC}"
  ((ERRORS++))
fi

if command -v npm &> /dev/null; then
  NPM_VERSION=$(npm --version)
  echo -e "  ${GREEN}✅ NPM instalado: $NPM_VERSION${NC}"
  ((SUCCESS++))
else
  echo -e "  ${RED}❌ NPM não encontrado${NC}"
  ((ERRORS++))
fi
echo ""

# ==============================================================================
# 2. Dependências
# ==============================================================================
echo -e "${CYAN}2️⃣  Verificando dependências...${NC}"
if [ -d "node_modules" ]; then
  MODULES_COUNT=$(find node_modules -maxdepth 1 -type d | wc -l)
  echo -e "  ${GREEN}✅ node_modules existe ($MODULES_COUNT pacotes)${NC}"
  ((SUCCESS++))
  
  # Verificar se package-lock.json está sincronizado
  if [ -f "package-lock.json" ]; then
    echo -e "  ${GREEN}✅ package-lock.json presente${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${YELLOW}⚠️  package-lock.json não encontrado${NC}"
    ((WARNINGS++))
  fi
else
  echo -e "  ${RED}❌ node_modules não encontrado. Execute: npm install${NC}"
  ((ERRORS++))
fi
echo ""

# ==============================================================================
# 3. Git
# ==============================================================================
echo -e "${CYAN}3️⃣  Verificando Git...${NC}"
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current)
  echo -e "  ${GREEN}✅ Repositório Git inicializado (branch: $BRANCH)${NC}"
  ((SUCCESS++))
  
  # Verificar status
  if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "  ${GREEN}✅ Working tree limpo${NC}"
    ((SUCCESS++))
  else
    MODIFIED=$(git status --short | wc -l)
    echo -e "  ${YELLOW}⚠️  $MODIFIED arquivo(s) modificado(s)${NC}"
    ((WARNINGS++))
  fi
  
  # Verificar Husky
  if [ -d ".husky" ]; then
    echo -e "  ${GREEN}✅ Git hooks (Husky) configurados${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${YELLOW}⚠️  Git hooks não configurados. Execute: npm run prepare${NC}"
    ((WARNINGS++))
  fi
else
  echo -e "  ${YELLOW}⚠️  Não é um repositório Git${NC}"
  ((WARNINGS++))
fi
echo ""

# ==============================================================================
# 4. TypeScript
# ==============================================================================
echo -e "${CYAN}4️⃣  Verificando TypeScript...${NC}"
if [ -f "tsconfig.json" ]; then
  echo -e "  ${GREEN}✅ tsconfig.json presente${NC}"
  ((SUCCESS++))
  
  # Executar type-check
  echo -e "  ${CYAN}   Executando type-check...${NC}"
  if npm run type-check > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ Sem erros de TypeScript${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${RED}❌ Erros de TypeScript encontrados${NC}"
    echo -e "  ${YELLOW}   Execute: npm run type-check para detalhes${NC}"
    ((ERRORS++))
  fi
else
  echo -e "  ${RED}❌ tsconfig.json não encontrado${NC}"
  ((ERRORS++))
fi
echo ""

# ==============================================================================
# 5. ESLint
# ==============================================================================
echo -e "${CYAN}5️⃣  Verificando ESLint...${NC}"
if [ -f "eslint.config.js" ]; then
  echo -e "  ${GREEN}✅ eslint.config.js presente${NC}"
  ((SUCCESS++))
  
  # Executar lint
  echo -e "  ${CYAN}   Executando lint...${NC}"
  LINT_OUTPUT=$(npm run lint 2>&1)
  if echo "$LINT_OUTPUT" | grep -q "0 errors"; then
    echo -e "  ${GREEN}✅ Sem erros de ESLint${NC}"
    ((SUCCESS++))
    
    # Verificar warnings
    if echo "$LINT_OUTPUT" | grep -q "warnings"; then
      WARNINGS_COUNT=$(echo "$LINT_OUTPUT" | grep -oP '\d+(?= warnings)' || echo "0")
      echo -e "  ${YELLOW}⚠️  $WARNINGS_COUNT warning(s) de ESLint${NC}"
      ((WARNINGS++))
    fi
  else
    echo -e "  ${RED}❌ Erros de ESLint encontrados${NC}"
    echo -e "  ${YELLOW}   Execute: npm run lint para detalhes${NC}"
    ((ERRORS++))
  fi
else
  echo -e "  ${RED}❌ eslint.config.js não encontrado${NC}"
  ((ERRORS++))
fi
echo ""

# ==============================================================================
# 6. Prettier
# ==============================================================================
echo -e "${CYAN}6️⃣  Verificando Prettier...${NC}"
if [ -f ".prettierrc" ]; then
  echo -e "  ${GREEN}✅ .prettierrc presente${NC}"
  ((SUCCESS++))
  
  # Verificar formatação
  echo -e "  ${CYAN}   Verificando formatação...${NC}"
  if npm run format:check > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ Código formatado corretamente${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${YELLOW}⚠️  Código precisa ser formatado${NC}"
    echo -e "  ${YELLOW}   Execute: npm run format${NC}"
    ((WARNINGS++))
  fi
else
  echo -e "  ${YELLOW}⚠️  .prettierrc não encontrado${NC}"
  ((WARNINGS++))
fi
echo ""

# ==============================================================================
# 7. Estrutura de Arquivos
# ==============================================================================
echo -e "${CYAN}7️⃣  Verificando estrutura de arquivos...${NC}"

REQUIRED_FILES=(
  "package.json"
  "vite.config.ts"
  "index.html"
  "src/main.tsx"
  "src/App.tsx"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo -e "  ${GREEN}✅ $file${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${RED}❌ $file não encontrado${NC}"
    ((ERRORS++))
  fi
done

REQUIRED_DIRS=(
  "src"
  "src/pages"
  "src/layouts"
  "src/shadcn"
  "public"
  "cli"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo -e "  ${GREEN}✅ $dir/${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${YELLOW}⚠️  $dir/ não encontrado${NC}"
    ((WARNINGS++))
  fi
done
echo ""

# ==============================================================================
# 8. CLI Tools
# ==============================================================================
echo -e "${CYAN}8️⃣  Verificando CLI tools...${NC}"
if [ -d "cli" ]; then
  SCRIPTS=$(find cli -name "*.sh" -type f | wc -l)
  echo -e "  ${GREEN}✅ Diretório CLI existe ($SCRIPTS scripts)${NC}"
  ((SUCCESS++))
  
  # Verificar se scripts são executáveis
  NON_EXECUTABLE=$(find cli -name "*.sh" -type f ! -executable | wc -l)
  if [ "$NON_EXECUTABLE" -eq 0 ]; then
    echo -e "  ${GREEN}✅ Todos os scripts são executáveis${NC}"
    ((SUCCESS++))
  else
    echo -e "  ${YELLOW}⚠️  $NON_EXECUTABLE script(s) não executável(is)${NC}"
    echo -e "  ${YELLOW}   Execute: chmod +x cli/*.sh${NC}"
    ((WARNINGS++))
  fi
else
  echo -e "  ${YELLOW}⚠️  Diretório CLI não encontrado${NC}"
  ((WARNINGS++))
fi
echo ""

# ==============================================================================
# 9. Vulnerabilidades
# ==============================================================================
echo -e "${CYAN}9️⃣  Verificando vulnerabilidades...${NC}"
AUDIT_OUTPUT=$(npm audit 2>&1)

if echo "$AUDIT_OUTPUT" | grep -q "found 0 vulnerabilities"; then
  echo -e "  ${GREEN}✅ Nenhuma vulnerabilidade encontrada${NC}"
  ((SUCCESS++))
else
  CRITICAL=$(echo "$AUDIT_OUTPUT" | grep -oP '\d+(?= critical)' || echo "0")
  HIGH=$(echo "$AUDIT_OUTPUT" | grep -oP '\d+(?= high)' || echo "0")
  
  if [ "$CRITICAL" -gt 0 ] || [ "$HIGH" -gt 0 ]; then
    echo -e "  ${RED}❌ Vulnerabilidades encontradas:${NC}"
    [ "$CRITICAL" -gt 0 ] && echo -e "  ${RED}   • $CRITICAL crítica(s)${NC}"
    [ "$HIGH" -gt 0 ] && echo -e "  ${RED}   • $HIGH alta(s)${NC}"
    echo -e "  ${YELLOW}   Execute: npm audit fix${NC}"
    ((ERRORS++))
  else
    echo -e "  ${YELLOW}⚠️  Vulnerabilidades de baixo/médio risco encontradas${NC}"
    echo -e "  ${YELLOW}   Execute: npm audit para detalhes${NC}"
    ((WARNINGS++))
  fi
fi
echo ""

# ==============================================================================
# 10. Build
# ==============================================================================
echo -e "${CYAN}🔟 Verificando build...${NC}"
if [ -d "dist" ]; then
  DIST_SIZE=$(du -sh dist 2>/dev/null | awk '{print $1}' || echo "N/A")
  echo -e "  ${GREEN}✅ Build existe (tamanho: $DIST_SIZE)${NC}"
  ((SUCCESS++))
else
  echo -e "  ${YELLOW}⚠️  Build não encontrado${NC}"
  echo -e "  ${YELLOW}   Execute: npm run build${NC}"
  ((WARNINGS++))
fi
echo ""

# ==============================================================================
# RESUMO
# ==============================================================================
echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║                   RESUMO DO HEALTH CHECK              ║${NC}"
echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}✅ Sucessos: $SUCCESS${NC}"
echo -e "  ${YELLOW}⚠️  Avisos: $WARNINGS${NC}"
echo -e "  ${RED}❌ Erros: $ERRORS${NC}"
echo ""

# Status final
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║  🎉 PROJETO 100% SAUDÁVEL! Pronto para produção!     ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
  exit 0
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "${YELLOW}╔═══════════════════════════════════════════════════════╗${NC}"
  echo -e "${YELLOW}║  ⚠️  PROJETO OK com avisos. Resolva quando possível.  ║${NC}"
  echo -e "${YELLOW}╚═══════════════════════════════════════════════════════╝${NC}"
  exit 0
else
  echo -e "${RED}╔═══════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║  ❌ PROJETO COM ERROS! Corrija antes de continuar.   ║${NC}"
  echo -e "${RED}╚═══════════════════════════════════════════════════════╝${NC}"
  exit 1
fi
