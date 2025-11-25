#!/bin/bash

# =============================================================================
# Script: analyze-bundle.sh
# Descrição: Analisa o tamanho do bundle e gera relatório
# Uso: ./cli/analyze-bundle.sh
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

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  📊 Análise de Bundle${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar se o build existe
if [ ! -d "dist" ]; then
  echo -e "${YELLOW}⚠️  Diretório 'dist' não encontrado. Executando build...${NC}"
  npm run build
  echo ""
fi

echo -e "${CYAN}📦 Analisando arquivos do bundle...${NC}"
echo ""

# Análise de arquivos JavaScript
echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║              ARQUIVOS JAVASCRIPT                      ║${NC}"
echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════╝${NC}"
find dist -name "*.js" -type f -exec ls -lh {} \; | awk '{print $9 " - " $5}' | sort -k3 -hr
echo ""

# Análise de arquivos CSS
echo -e "${MAGENTA}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║                 ARQUIVOS CSS                          ║${NC}"
echo -e "${MAGENTA}╚═══════════════════════════════════════════════════════╝${NC}"
find dist -name "*.css" -type f -exec ls -lh {} \; | awk '{print $9 " - " $5}' | sort -k3 -hr
echo ""

# Tamanho total
TOTAL_SIZE=$(du -sh dist | awk '{print $1}')
echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              TAMANHO TOTAL DO BUNDLE                  ║${NC}"
echo -e "${GREEN}╠═══════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║  ${TOTAL_SIZE}                                          ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# Contar arquivos
JS_COUNT=$(find dist -name "*.js" -type f | wc -l)
CSS_COUNT=$(find dist -name "*.css" -type f | wc -l)
TOTAL_COUNT=$(find dist -type f | wc -l)

echo -e "${CYAN}📈 Estatísticas:${NC}"
echo -e "  • Arquivos JavaScript: ${YELLOW}$JS_COUNT${NC}"
echo -e "  • Arquivos CSS: ${YELLOW}$CSS_COUNT${NC}"
echo -e "  • Total de arquivos: ${YELLOW}$TOTAL_COUNT${NC}"
echo ""

# Verificar arquivos grandes (> 500KB)
echo -e "${CYAN}🔍 Arquivos grandes (> 500KB):${NC}"
LARGE_FILES=$(find dist -type f -size +500k)
if [ -z "$LARGE_FILES" ]; then
  echo -e "${GREEN}  ✅ Nenhum arquivo maior que 500KB encontrado!${NC}"
else
  echo "$LARGE_FILES" | while read -r file; do
    SIZE=$(du -h "$file" | awk '{print $1}')
    echo -e "${YELLOW}  ⚠️  $file - $SIZE${NC}"
  done
fi
echo ""

# Dicas de otimização
echo -e "${BLUE}💡 Dicas de otimização:${NC}"
echo "  1. Use code splitting para reduzir o bundle inicial"
echo "  2. Implemente lazy loading para rotas e componentes pesados"
echo "  3. Analise dependências com 'npm run build -- --profile'"
echo "  4. Considere usar rollup-plugin-visualizer para análise visual"
echo "  5. Remova dependências não utilizadas"
echo ""

echo -e "${GREEN}✅ Análise concluída!${NC}"
