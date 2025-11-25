#!/usr/bin/env bash
set -euo pipefail

# Simple, single-run page creator.
# Usage: ./cli/create-page.sh PageName [route]
# If no args provided, runs interactively once and exits.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<EOF
Usage: ./cli/create-page.sh PageName [route]
Examples:
  ./cli/create-page.sh About
  ./cli/create-page.sh UserProfile /profile
If no args provided the script will prompt interactively. The script creates the page files and an export in src/pages/index.ts and then exits.
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

PAGE_NAME="${1:-}"
ROUTE_INPUT="${2:-}"

if [[ -z "$PAGE_NAME" ]]; then
  read -r -p "Page Name (PascalCase, e.g. About): " PAGE_NAME
fi

if [[ -z "$PAGE_NAME" ]]; then
  echo "Page name required"
  exit 1
fi

# If route was not passed as second arg, prompt once interactively
if [[ -z "$ROUTE_INPUT" ]]; then
  read -r -p "Route path (e.g. about or /contact). Leave empty for /${PAGE_NAME,,}: " ROUTE_INPUT
fi

# normalize route
if [[ -z "$ROUTE_INPUT" ]]; then
  ROUTE_PATH="${PAGE_NAME,,}"
else
  ROUTE_PATH="${ROUTE_INPUT#/}"
fi

# validate PascalCase
if [[ ! "$PAGE_NAME" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
  echo "Page name must be PascalCase (e.g. About, UserProfile)"
  exit 1
fi

PAGE_DIR="src/pages/$PAGE_NAME"
PAGE_FILE="$PAGE_DIR/$PAGE_NAME.tsx"

if [[ -e "$PAGE_FILE" ]]; then
  echo "Page file already exists: $PAGE_FILE"
  exit 1
fi

mkdir -p "$PAGE_DIR"

cat > "$PAGE_FILE" <<EOF
import { AppContainer } from "@/layouts"
import { Title, Text } from "@/shadcn/components/ui/typography"
import { VStack } from "@/shadcn/components/ui/layout"

export function Component() {
  return (
    <AppContainer>
      <VStack className="gap-4 py-12 items-start">
        <Title size="2xl" className="font-heading font-bold">
          $PAGE_NAME
        </Title>
        <Text className="text-muted">Esta é a página $PAGE_NAME.</Text>
      </VStack>
    </AppContainer>
  )
}

EOF

echo "Created $PAGE_FILE"

# add export to src/pages/index.ts (create/append)
PAGES_INDEX="src/pages/index.ts"
EXPORT_LINE="export { Component as $PAGE_NAME } from \"./$PAGE_NAME/$PAGE_NAME\";"

if [[ -f "$PAGES_INDEX" ]]; then
  if grep -qF "$EXPORT_LINE" "$PAGES_INDEX" 2>/dev/null; then
    echo "Export already present in $PAGES_INDEX"
  else
    echo "$EXPORT_LINE" >> "$PAGES_INDEX"
    echo "Added export to $PAGES_INDEX"
  fi
else
  echo "$EXPORT_LINE" > "$PAGES_INDEX"
  echo "Created $PAGES_INDEX and added export"
fi

echo "NOTE: This script creates the page files and an export in \`src/pages/index.ts\`."

# Attempt to insert a lazy route into src/App.tsx inside the MainLayout block (best-effort)
APP_FILE="src/App.tsx"
if [[ -f "$APP_FILE" ]]; then
  ROUTE_INS="        <Route path=\"$ROUTE_PATH\" lazy={() => import(\"@pages/$PAGE_NAME/$PAGE_NAME\")} />"
  awk -v ins="$ROUTE_INS" '
    BEGIN{ml=0}
    {
      if (index($0, "<Route element") && index($0, "MainLayout")) { print $0; ml=1; next }
      if (ml==1 && index($0, "</Route>")) { print ins; ml=0 }
      print $0
    }
  ' "$APP_FILE" > "$APP_FILE.tmp" && mv "$APP_FILE.tmp" "$APP_FILE" || true
  echo "Best-effort: inserted lazy route into $APP_FILE inside MainLayout block (if a matching block was found)"
else
  echo "Warning: $APP_FILE not found. Skipped App.tsx updates."
fi

# format created files if prettier available
if command -v npx >/dev/null 2>&1; then
  echo "Formatting created files with Prettier..."
  npx prettier --write "$PAGE_FILE" "$PAGES_INDEX" "$APP_FILE" >/dev/null || true
fi

echo "Done. Route suggestion: /$ROUTE_PATH -> $PAGE_NAME"
exit 0
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<EOF
Usage: ./cli/create-page.sh [PageName] [route]
Examples:
  ./cli/create-page.sh About
  ./cli/create-page.sh UserProfile /profile
If no args provided the script will prompt interactively.
EOF
}

PAGE_NAME=""
ROUTE_INPUT=""

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ge 1 ]]; then
  PAGE_NAME="$1"
  ROUTE_INPUT="${2:-}"
else
  read -r -p "Page Name (PascalCase, e.g. About): " PAGE_NAME
  read -r -p "Route path (e.g. about or /contact). Leave empty for /${PAGE_NAME,,}: " ROUTE_INPUT
fi

if [[ -z "$PAGE_NAME" ]]; then
  echo "Page name required"
  exit 1
fi

# normalize route
if [[ -z "$ROUTE_INPUT" ]]; then
  ROUTE_PATH="${PAGE_NAME,,}"
else
  ROUTE_PATH="${ROUTE_INPUT#/}"
fi

# validate PascalCase
if [[ ! "$PAGE_NAME" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
  echo "Page name must be PascalCase (e.g. About, UserProfile)"
  exit 1
fi

PAGE_DIR="src/pages/$PAGE_NAME"
PAGE_FILE="$PAGE_DIR/$PAGE_NAME.tsx"

if [[ -e "$PAGE_FILE" ]]; then
  echo "Page file already exists: $PAGE_FILE"
  exit 1
fi

mkdir -p "$PAGE_DIR"

cat > "$PAGE_FILE" <<EOF
import { AppContainer } from "@/layouts"
import { Title, Text } from "@/shadcn/components/ui/typography"
import { VStack } from "@/shadcn/components/ui/layout"

export function Component() {
  return (
    <AppContainer>
      <VStack className="gap-4 py-12 items-start">
        <Title size="2xl" className="font-heading font-bold">
          $PAGE_NAME
        </Title>
        <Text className="text-muted">Esta é a página $PAGE_NAME.</Text>
      </VStack>
    </AppContainer>
  )
}

EOF

echo "Created $PAGE_FILE"

# add export to src/pages/index.ts
PAGES_INDEX="src/pages/index.ts"
if [[ -f "$PAGES_INDEX" ]]; then
  if grep -q -w "$PAGE_NAME" "$PAGES_INDEX" 2>/dev/null; then
    echo "Export already present in $PAGES_INDEX"
  else
    echo "export { $PAGE_NAME } from \"./$PAGE_NAME/$PAGE_NAME\";" >> "$PAGES_INDEX"
    echo "Added export to $PAGES_INDEX"
  fi
else
  echo "export { $PAGE_NAME } from \"./$PAGE_NAME/$PAGE_NAME\";" > "$PAGES_INDEX"
  echo "Created $PAGES_INDEX and added export"
fi

# Update src/App.tsx: add import from @pages and insert route
APP_FILE="src/App.tsx"
if [[ -f "$APP_FILE" ]]; then
  # We do NOT add an import for the new page; routes will be lazy-loaded.
  if grep -q "from \"@pages\"" "$APP_FILE"; then
    echo "Detected @pages import block in $APP_FILE — skipping adding static import (will use lazy route)."
  else
    echo "Note: no '@pages' import found in $APP_FILE — skipping import insertion (routes will be lazy)."
  fi

  # insert route before NotFound wildcard if present (safer awk-based insertion)
  if grep -q "NotFound" "$APP_FILE" 2>/dev/null; then
    # insert a lazy route before the NotFound route (best-effort)
  awk -v ins="        <Route path=\"$ROUTE_PATH\" lazy={()=> import(\"@pages/$PAGE_NAME/$PAGE_NAME\")} />" '{ if (index($0, "NotFound") ) { print ins } print }' "$APP_FILE" > "$APP_FILE.tmp" && mv "$APP_FILE.tmp" "$APP_FILE" || true
    echo "Inserted lazy route into $APP_FILE before NotFound (best-effort)"
  else
    # fallback: append route inside MainLayout block (find MainLayout start, insert before its closing </Route>)
    awk -v ins="        <Route path=\"$ROUTE_PATH\" lazy={()=> import(\"@pages/$PAGE_NAME/$PAGE_NAME\")} />" '
      BEGIN{ml=0}
      { print $0 }
      /<Route element=\{<MainLayout \/>\}>/{ ml=1; next }
      ml && /<\/Route>/{ print ins; ml=0 }
    ' "$APP_FILE" > "$APP_FILE.tmp" && mv "$APP_FILE.tmp" "$APP_FILE"
    echo "Appended route into $APP_FILE inside MainLayout block (best-effort)"
  fi
else
  echo "Warning: $APP_FILE not found. Skipped App.tsx updates."
fi

# run prettier if available
if command -v npx >/dev/null 2>&1; then
  echo "Formatting created files with Prettier..."
  npx prettier --write "$PAGE_FILE" "$PAGES_INDEX" "$APP_FILE" >/dev/null || true
fi

echo "Done. Route: /$ROUTE_PATH -> $PAGE_NAME"
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<EOF
Usage: ./cli/create-page.sh [PageName] [route]
Examples:
  ./cli/create-page.sh About
  ./cli/create-page.sh UserProfile /profile
If no args provided the script will prompt interactively.
EOF
}

PAGE_NAME=""
ROUTE_INPUT=""

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ge 1 ]]; then
  PAGE_NAME="$1"
  ROUTE_INPUT="${2:-}"
else
  read -r -p "Page Name (PascalCase, e.g. About): " PAGE_NAME
  read -r -p "Route path (e.g. about or /contact). Leave empty for /${PAGE_NAME,,}: " ROUTE_INPUT
fi

if [[ -z "$PAGE_NAME" ]]; then
  echo "Page name required"
  exit 1
fi

# normalize route
if [[ -z "$ROUTE_INPUT" ]]; then
  ROUTE_PATH="${PAGE_NAME,,}"
else
  ROUTE_PATH="${ROUTE_INPUT#/}"
fi

# validate PascalCase
if [[ ! "$PAGE_NAME" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
  echo "Page name must be PascalCase (e.g. About, UserProfile)"
  exit 1
fi

PAGE_DIR="src/pages/$PAGE_NAME"
PAGE_FILE="$PAGE_DIR/$PAGE_NAME.tsx"

if [[ -e "$PAGE_FILE" ]]; then
  echo "Page file already exists: $PAGE_FILE"
  exit 1
fi

mkdir -p "$PAGE_DIR"

cat > "$PAGE_FILE" <<EOF
import { AppContainer } from "@/layouts"
import { Title, Text } from "@/shadcn/components/ui/typography"
import { VStack } from "@/shadcn/components/ui/layout"

export function Component() {
  return (
    <AppContainer>
      <VStack className="gap-4 py-12 items-start">
        <Title size="2xl" className="font-heading font-bold">
          $PAGE_NAME
        </Title>
        <Text className="text-muted">Esta é a página $PAGE_NAME.</Text>
      </VStack>
    </AppContainer>
  )
}

EOF

echo "Created $PAGE_FILE"

# add export to src/pages/index.ts
PAGES_INDEX="src/pages/index.ts"
if [[ -f "$PAGES_INDEX" ]]; then
  if grep -q -w "$PAGE_NAME" "$PAGES_INDEX" 2>/dev/null; then
    echo "Export already present in $PAGES_INDEX"
  else
    echo "export { $PAGE_NAME } from \"./$PAGE_NAME/$PAGE_NAME\";" >> "$PAGES_INDEX"
    echo "Added export to $PAGES_INDEX"
  fi
else
  echo "export { $PAGE_NAME } from \"./$PAGE_NAME/$PAGE_NAME\";" > "$PAGES_INDEX"
  echo "Created $PAGES_INDEX and added export"
fi

# Update src/App.tsx: add import from @pages and insert route
APP_FILE="src/App.tsx"
if [[ -f "$APP_FILE" ]]; then
  # add to existing import from "@pages"
  if grep -q "from \"@pages\"" "$APP_FILE"; then
    if grep -q -w "$PAGE_NAME" "$APP_FILE"; then
      echo "$PAGE_NAME already referenced in $APP_FILE"
    else
      # safe perl substitution to append into brace list
      perl -0777 -pe "s/import\s*\{\s*([^}]*)\s*\}\s*from\s*\"@pages\"\s*;/import { \1, $PAGE_NAME } from \"@pages\";/s" -i "$APP_FILE"
      echo "Updated import in $APP_FILE"
    fi
  else
    # insert a new simple import near top (after library imports)
    awk -v ins="import { $PAGE_NAME } from \"@pages\";" 'NR==1{print; next} {print} END{print ins}' "$APP_FILE" > "$APP_FILE.tmp" && mv "$APP_FILE.tmp" "$APP_FILE"
    echo "Added import line to $APP_FILE"
  fi

  # insert route before NotFound wildcard if present
  if grep -q "<Route path=\"\*\" element=\{<NotFound \/>\} \/>" "$APP_FILE"; then
    perl -0777 -pe "s/(<Route path=\"\\*\" element=\{<NotFound \/>\} \/>)/        <Route path=\"$ROUTE_PATH\" element=\{<$PAGE_NAME \/>\} \/>\n\1/s" -i "$APP_FILE"
    echo "Inserted route into $APP_FILE before NotFound"
  else
    # fallback: append route inside MainLayout block
    perl -0777 -pe "s/(<Route element=\{<MainLayout \/>\}>\s*)([\s\S]*?)(<\/Route>)/\1\2\n        <Route path=\"$ROUTE_PATH\" element=\{<$PAGE_NAME \/>\} \/>\n\3/s" -i "$APP_FILE"
    echo "Appended route into $APP_FILE"
  fi
else
  echo "Warning: $APP_FILE not found. Skipped App.tsx updates."
fi

# run prettier if available
if command -v npx >/dev/null 2>&1; then
  echo "Formatting created files with Prettier..."
  npx prettier --write "$PAGE_FILE" "$PAGES_INDEX" "$APP_FILE" >/dev/null || true
fi

echo "Done. Route: /$ROUTE_PATH -> $PAGE_NAME"
#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Create a new page under src/pages"
read -r -p "Page Name (PascalCase, e.g. About): " PAGE_NAME
if [[ -z "$PAGE_NAME" ]]; then
  echo "Page name required"
  exit 1
fi

read -r -p "Route path (e.g. about or /contact). Leave empty for /${PAGE_NAME,,}: " ROUTE_INPUT
if [[ -z "$ROUTE_INPUT" ]]; then
  ROUTE_PATH="${PAGE_NAME,,}"
else
  ROUTE_PATH="${ROUTE_INPUT#/}"
fi

PAGE_DIR="src/pages/$PAGE_NAME"
PAGE_FILE="$PAGE_DIR/$PAGE_NAME.tsx"

if [[ -e "$PAGE_FILE" ]]; then
  echo "Page file already exists: $PAGE_FILE"
  exit 1
fi

mkdir -p "$PAGE_DIR"

cat > "$PAGE_FILE" <<EOF
import { AppContainer } from "@/layouts"
import { Title, Text } from "@/shadcn/components/ui/typography"
import { VStack } from "@/shadcn/components/ui/layout"

export function Component() {
  return (
    <AppContainer>
      <VStack className="gap-4 py-12 items-start">
        <Title size="2xl" className="font-heading font-bold">
          $PAGE_NAME
        </Title>
        <Text className="text-muted">Esta é a página $PAGE_NAME.</Text>
      </VStack>
    </AppContainer>
  )
}

EOF

echo "Created $PAGE_FILE"

# Add export to src/pages/index.ts
PAGES_INDEX="src/pages/index.ts"
if grep -q "export \{ .*\} from \"./$PAGE_NAME/$PAGE_NAME\";" "$PAGES_INDEX" 2>/dev/null; then
  echo "Export already present in $PAGES_INDEX"
else
  echo "export { $PAGE_NAME } from \"./$PAGE_NAME/$PAGE_NAME\";" >> "$PAGES_INDEX"
  echo "Added export to $PAGES_INDEX"
fi

# Update src/App.tsx imports to include the new page
APP_FILE="src/App.tsx"
if grep -q "from \"@pages\"" "$APP_FILE"; then
  # insert into existing brace list
  # avoid duplicate if already present
  if grep -q "\b$PAGE_NAME\b" "$APP_FILE"; then
    echo "$PAGE_NAME already imported in $APP_FILE"
  else
    perl -0777 -pe "s/import\s*\{\s*([^}]*)\s*\}\s*from\s*\"@pages\"\s*;/import { \1, $PAGE_NAME } from \"@pages\";/s" -i "$APP_FILE"
    echo "Updated import in $APP_FILE"
  fi
else
  # add a new import after the existing imports block
  sed -i "/import .* from .*react-router-dom"/a\
import { $PAGE_NAME } from \"@pages\";" "$APP_FILE" || true
  echo "Added import line to $APP_FILE"
fi

# Insert the new route before the NotFound wildcard route if present, otherwise append inside MainLayout
ROUTE_LINE="        <Route path=\"$ROUTE_PATH\" element={<$PAGE_NAME />} />"
if grep -q "<Route path=\"\*\" element={<NotFound />} />" "$APP_FILE"; then
  awk -v newline="$ROUTE_LINE" '{
    print $0
    if ($0 ~ /<Route path="\*" element=\{<NotFound \/>\} \/>/) {
      # no-op, handled by insertion before line
    }
  }' "$APP_FILE" > "$APP_FILE.tmp"
  # insert before the NotFound line
  perl -0777 -pe "s/(\n\s*)<Route path=\"\*\" element=\{<NotFound \/>\} \/>(\n)/\n        <Route path=\"$ROUTE_PATH\" element={<$PAGE_NAME />} />\n        <Route path=\"*\" element={<NotFound />} />\n/s" -i "$APP_FILE"
  echo "Inserted route into $APP_FILE"
else
  # fallback: append route inside the MainLayout block
  perl -0777 -pe "s/(<Route element=\{<MainLayout \/>\}>\s*)([\s\S]*?)(<\/Route>)/\1\2\n        <Route path=\"$ROUTE_PATH\" element={<$PAGE_NAME />} />\n\3/s" -i "$APP_FILE"
  echo "Appended route into $APP_FILE"
fi

# Run prettier if available
if command -v npx >/dev/null 2>&1; then
  echo "Formatting files with Prettier..."
  npx prettier --write "$PAGE_FILE" "$PAGES_INDEX" "$APP_FILE" >/dev/null || true
fi

echo "Done. Route: /$ROUTE_PATH -> $PAGE_NAME"
#!/bin/bash

# =============================================================================
# Script: create-page.sh
# Descrição: Cria uma nova página com rota no React Router
# Uso: ./cli/create-page.sh <PageName> [route]
# Exemplo: ./cli/create-page.sh About /about
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função de ajuda
show_help() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  📄 Criador de Páginas React${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${YELLOW}Uso:${NC}"
  echo "  ./cli/create-page.sh <PageName> [route]"
  echo ""
  echo -e "${YELLOW}Argumentos:${NC}"
  echo "  PageName  Nome da página (PascalCase)"
  echo "  route     Rota da página (padrão: /nome-em-kebab-case)"
  echo ""
  echo -e "${YELLOW}Exemplos:${NC}"
  echo "  ./cli/create-page.sh About"
  echo "  ./cli/create-page.sh UserProfile /profile"
  echo "  ./cli/create-page.sh ContactUs /contact"
  echo ""
}

# Validar argumentos
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
  exit 0
fi

PAGE_NAME=$1
# Converter PascalCase para kebab-case para a rota padrão
DEFAULT_ROUTE=$(echo "$PAGE_NAME" | sed 's/\([A-Z]\)/-\1/g' | sed 's/^-//' | tr '[:upper:]' '[:lower:]')
ROUTE=${2:-"/$DEFAULT_ROUTE"}
PAGE_DIR="src/pages/$PAGE_NAME"

# Validar nome da página (PascalCase)
if [[ ! $PAGE_NAME =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
  echo -e "${RED}❌ Erro: Nome da página deve estar em PascalCase (ex: MyPage)${NC}"
  exit 1
fi

# Verificar se a página já existe
if [ -d "$PAGE_DIR" ]; then
  echo -e "${RED}❌ Erro: Página '$PAGE_NAME' já existe em $PAGE_DIR${NC}"
  exit 1
fi

# Criar diretório
echo -e "${BLUE}📁 Criando diretório: $PAGE_DIR${NC}"
mkdir -p "$PAGE_DIR"

# Criar arquivo da página
echo -e "${BLUE}📝 Criando $PAGE_NAME.tsx${NC}"
cat > "$PAGE_DIR/$PAGE_NAME.tsx" << EOF
import { AppContainer } from "@/layouts"
import { Title, Text } from "@/shadcn/components/ui/typography"
import { VStack } from "@/shadcn/components/ui/layout"

export function Component() {
  return (
    <AppContainer>
      <VStack className="gap-4 py-12 items-start">
        <Title size="2xl" className="font-heading font-bold">
          $PAGE_NAME
        </Title>
        <Text className="text-muted">Esta é a página $PAGE_NAME.</Text>
      </VStack>
    </AppContainer>
  )
}
EOF

# Criar arquivo index para exportação
echo -e "${BLUE}📝 Criando index.ts${NC}"
cat > "$PAGE_DIR/index.ts" << EOF
export { ${PAGE_NAME} } from './${PAGE_NAME}';
EOF

# Criar README da página
echo -e "${BLUE}📄 Criando README.md${NC}"
cat > "$PAGE_DIR/README.md" << EOF
# ${PAGE_NAME}

## Descrição
Página ${PAGE_NAME} do aplicativo.

## Rota
\`${ROUTE}\`

## Estrutura
- Usa \`AppContainer\` para layout consistente
- Componentes de tipografia do Design System
- Layout com \`VStack\` para organização vertical

## Exemplo de Uso no Router

\`\`\`tsx
import { ${PAGE_NAME} } from '@pages/${PAGE_NAME}';

// Em App.tsx ou routes.tsx
<Route path="${ROUTE}" element={<${PAGE_NAME} />} />
\`\`\`
EOF

echo ""
echo -e "${GREEN}✅ Página '$PAGE_NAME' criada com sucesso!${NC}"
echo -e "${GREEN}📍 Localização: $PAGE_DIR${NC}"
echo -e "${GREEN}🌐 Rota sugerida: ${ROUTE}${NC}"
echo ""
echo -e "${YELLOW}Arquivos criados:${NC}"
echo "  ├─ $PAGE_NAME.tsx"
echo "  ├─ index.ts"
echo "  └─ README.md"
echo ""
echo -e "${BLUE}💡 Próximos passos:${NC}"
echo "  1. Adicione a rota em src/App.tsx:"
echo ""
echo -e "${YELLOW}     import { ${PAGE_NAME} } from '@pages/${PAGE_NAME}';${NC}"
echo -e "${YELLOW}     <Route path=\"${ROUTE}\" element={<${PAGE_NAME} />} />${NC}"
echo ""
echo "  2. Edite o conteúdo da página em $PAGE_DIR/$PAGE_NAME.tsx"
echo "  3. Teste navegando para ${ROUTE}"
echo ""
