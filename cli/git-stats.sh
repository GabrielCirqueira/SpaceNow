#!/bin/bash

# =============================================================================
# Script: git-stats.sh
# Descrição: Exibe estatísticas detalhadas do repositório Git
# Uso: ./cli/git-stats.sh
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
echo -e "${BLUE}  📊 Estatísticas do Repositório Git${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar se está em um repositório Git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Erro: Não é um repositório Git${NC}"
  exit 1
fi

# 1. Informações básicas
echo -e "${CYAN}📁 Informações Básicas${NC}"
BRANCH=$(git branch --show-current)
REMOTE=$(git remote get-url origin 2>/dev/null || echo "Nenhum remote configurado")
echo -e "  • Branch atual: ${GREEN}$BRANCH${NC}"
echo -e "  • Remote: ${YELLOW}$REMOTE${NC}"
echo ""

# 2. Contagem de commits
echo -e "${CYAN}📝 Commits${NC}"
TOTAL_COMMITS=$(git rev-list --count HEAD)
TODAY_COMMITS=$(git rev-list --count --since="today" HEAD)
THIS_WEEK_COMMITS=$(git rev-list --count --since="1 week ago" HEAD)
THIS_MONTH_COMMITS=$(git rev-list --count --since="1 month ago" HEAD)

echo -e "  • Total de commits: ${GREEN}$TOTAL_COMMITS${NC}"
echo -e "  • Commits hoje: ${YELLOW}$TODAY_COMMITS${NC}"
echo -e "  • Commits esta semana: ${YELLOW}$THIS_WEEK_COMMITS${NC}"
echo -e "  • Commits este mês: ${YELLOW}$THIS_MONTH_COMMITS${NC}"
echo ""

# 3. Contribuidores
echo -e "${CYAN}👥 Top 5 Contribuidores${NC}"
git shortlog -sn --all | head -5 | while read -r line; do
  COUNT=$(echo "$line" | awk '{print $1}')
  AUTHOR=$(echo "$line" | cut -d$'\t' -f2)
  echo -e "  • ${GREEN}$COUNT${NC} commits - $AUTHOR"
done
echo ""

# 4. Estatísticas de arquivos
echo -e "${CYAN}📊 Estatísticas de Código${NC}"
TOTAL_FILES=$(git ls-files | wc -l)
echo -e "  • Total de arquivos versionados: ${GREEN}$TOTAL_FILES${NC}"
echo ""

# Top 5 arquivos mais modificados
echo -e "${CYAN}🔥 Top 5 Arquivos Mais Modificados${NC}"
git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -5 | while read -r line; do
  COUNT=$(echo "$line" | awk '{print $1}')
  FILE=$(echo "$line" | awk '{$1=""; print $0}' | xargs)
  if [ -n "$FILE" ]; then
    echo -e "  • ${YELLOW}$COUNT${NC} alterações - $FILE"
  fi
done
echo ""

# 5. Linhas de código adicionadas/removidas
echo -e "${CYAN}📈 Estatísticas de Linhas (Total)${NC}"
STATS=$(git log --shortstat --pretty=format:"" | awk '
  {
    files += $1
    inserted += $4
    deleted += $6
  }
  END {
    print files " " inserted " " deleted
  }
')

FILES_CHANGED=$(echo "$STATS" | awk '{print $1}')
LINES_ADDED=$(echo "$STATS" | awk '{print $2}')
LINES_DELETED=$(echo "$STATS" | awk '{print $3}')

echo -e "  • Arquivos alterados: ${GREEN}$FILES_CHANGED${NC}"
echo -e "  • Linhas adicionadas: ${GREEN}+$LINES_ADDED${NC}"
echo -e "  • Linhas removidas: ${RED}-$LINES_DELETED${NC}"
echo ""

# 6. Atividade recente
echo -e "${CYAN}⏰ Últimos 5 Commits${NC}"
git log --oneline --decorate -5 --color=always | while read -r line; do
  echo "  $line"
done
echo ""

# 7. Status atual
echo -e "${CYAN}📋 Status Atual${NC}"
STAGED=$(git diff --cached --numstat | wc -l)
MODIFIED=$(git diff --numstat | wc -l)
UNTRACKED=$(git ls-files --others --exclude-standard | wc -l)

if [ "$STAGED" -eq 0 ] && [ "$MODIFIED" -eq 0 ] && [ "$UNTRACKED" -eq 0 ]; then
  echo -e "  ${GREEN}✅ Working tree limpo${NC}"
else
  [ "$STAGED" -gt 0 ] && echo -e "  • Arquivos staged: ${GREEN}$STAGED${NC}"
  [ "$MODIFIED" -gt 0 ] && echo -e "  • Arquivos modificados: ${YELLOW}$MODIFIED${NC}"
  [ "$UNTRACKED" -gt 0 ] && echo -e "  • Arquivos não rastreados: ${RED}$UNTRACKED${NC}"
fi
echo ""

# 8. Branches
echo -e "${CYAN}🌿 Branches${NC}"
LOCAL_BRANCHES=$(git branch | wc -l)
REMOTE_BRANCHES=$(git branch -r | wc -l)
echo -e "  • Branches locais: ${GREEN}$LOCAL_BRANCHES${NC}"
echo -e "  • Branches remotas: ${YELLOW}$REMOTE_BRANCHES${NC}"
echo ""

# 9. Tags
TAGS=$(git tag | wc -l)
if [ "$TAGS" -gt 0 ]; then
  echo -e "${CYAN}🏷️  Tags${NC}"
  echo -e "  • Total de tags: ${GREEN}$TAGS${NC}"
  echo -e "  • Última tag: ${YELLOW}$(git describe --tags --abbrev=0 2>/dev/null || echo "N/A")${NC}"
  echo ""
fi

# 10. Tamanho do repositório
echo -e "${CYAN}💾 Tamanho do Repositório${NC}"
REPO_SIZE=$(du -sh .git 2>/dev/null | awk '{print $1}' || echo "N/A")
echo -e "  • Tamanho do .git: ${YELLOW}$REPO_SIZE${NC}"
echo ""

echo -e "${GREEN}✅ Análise concluída!${NC}"
