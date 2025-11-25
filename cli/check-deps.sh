#!/bin/bash

# =============================================================================
# Script: check-deps.sh
# Descrição: Verifica dependências desatualizadas e vulnerabilidades
# Uso: ./cli/check-deps.sh [--fix]
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

FIX_MODE=false

# Verificar flag --fix
if [ "$1" = "--fix" ]; then
  FIX_MODE=true
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🔍 Verificador de Dependências${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 1. Verificar dependências desatualizadas
echo -e "${CYAN}📦 Verificando dependências desatualizadas...${NC}"
echo ""
npm outdated || true
echo ""

# 2. Verificar vulnerabilidades
echo -e "${CYAN}🔒 Verificando vulnerabilidades de segurança...${NC}"
echo ""
AUDIT_OUTPUT=$(npm audit 2>&1)
echo "$AUDIT_OUTPUT"
echo ""

# Contar vulnerabilidades
CRITICAL=$(echo "$AUDIT_OUTPUT" | grep -oP '\d+(?= critical)' || echo "0")
HIGH=$(echo "$AUDIT_OUTPUT" | grep -oP '\d+(?= high)' || echo "0")
MODERATE=$(echo "$AUDIT_OUTPUT" | grep -oP '\d+(?= moderate)' || echo "0")
LOW=$(echo "$AUDIT_OUTPUT" | grep -oP '\d+(?= low)' || echo "0")

# Exibir resumo
echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║              RESUMO DE VULNERABILIDADES               ║${NC}"
echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════╝${NC}"
echo -e "  ${RED}🔴 Critical: $CRITICAL${NC}"
echo -e "  ${RED}🔴 High: $HIGH${NC}"
echo -e "  ${YELLOW}🟡 Moderate: $MODERATE${NC}"
echo -e "  ${GREEN}🟢 Low: $LOW${NC}"
echo ""

# 3. Verificar duplicatas
echo -e "${CYAN}🔄 Verificando dependências duplicadas...${NC}"
echo ""
npm dedupe --dry-run || true
echo ""

# 4. Verificar tamanho das dependências
echo -e "${CYAN}📊 Analisando tamanho das dependências...${NC}"
echo ""
if command -v du &> /dev/null; then
  NODE_MODULES_SIZE=$(du -sh node_modules 2>/dev/null | awk '{print $1}' || echo "N/A")
  echo -e "  Tamanho de node_modules: ${YELLOW}$NODE_MODULES_SIZE${NC}"
  
  # Top 10 maiores pacotes
  echo ""
  echo -e "${CYAN}🏋️  Top 10 maiores pacotes:${NC}"
  du -sh node_modules/* 2>/dev/null | sort -hr | head -10 | while read -r line; do
    SIZE=$(echo "$line" | awk '{print $1}')
    PKG=$(echo "$line" | awk '{print $2}')
    echo -e "  ${YELLOW}$SIZE${NC} - $(basename "$PKG")"
  done
fi
echo ""

# 5. Modo fix
if [ "$FIX_MODE" = true ]; then
  echo -e "${YELLOW}🔧 Modo de correção ativado!${NC}"
  echo ""
  
  echo -e "${CYAN}1️⃣  Atualizando dependências...${NC}"
  npm update
  echo ""
  
  echo -e "${CYAN}2️⃣  Corrigindo vulnerabilidades...${NC}"
  npm audit fix
  echo ""
  
  echo -e "${CYAN}3️⃣  Removendo duplicatas...${NC}"
  npm dedupe
  echo ""
  
  echo -e "${GREEN}✅ Correções aplicadas!${NC}"
  echo -e "${YELLOW}⚠️  Execute 'npm run validate' para verificar se tudo ainda funciona.${NC}"
  echo ""
else
  echo -e "${BLUE}💡 Dicas:${NC}"
  echo "  • Para atualizar dependências: npm update"
  echo "  • Para corrigir vulnerabilidades: npm audit fix"
  echo "  • Para corrigir automaticamente: ./cli/check-deps.sh --fix"
  echo "  • Para atualizar versões major: npx npm-check-updates -u"
  echo ""
fi

echo -e "${GREEN}✅ Verificação concluída!${NC}"
