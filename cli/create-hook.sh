#!/bin/bash

# =============================================================================
# Script: create-hook.sh
# Descrição: Cria um custom hook React com TypeScript
# Uso: ./cli/create-hook.sh <hookName>
# Exemplo: ./cli/create-hook.sh useLocalStorage
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
  echo -e "${BLUE}  🪝 Criador de Custom Hooks React${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${YELLOW}Uso:${NC}"
  echo "  ./cli/create-hook.sh <hookName>"
  echo ""
  echo -e "${YELLOW}Argumentos:${NC}"
  echo "  hookName  Nome do hook (deve começar com 'use')"
  echo ""
  echo -e "${YELLOW}Exemplos:${NC}"
  echo "  ./cli/create-hook.sh useLocalStorage"
  echo "  ./cli/create-hook.sh useDebounce"
  echo "  ./cli/create-hook.sh useFetch"
  echo ""
}

# Validar argumentos
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
  exit 0
fi

HOOK_NAME=$1
HOOKS_DIR="src/hooks"
HOOK_FILE="$HOOKS_DIR/$HOOK_NAME.ts"

# Validar nome do hook (deve começar com 'use')
if [[ ! $HOOK_NAME =~ ^use[A-Z][a-zA-Z0-9]*$ ]]; then
  echo -e "${RED}❌ Erro: Nome do hook deve começar com 'use' seguido de PascalCase (ex: useMyHook)${NC}"
  exit 1
fi

# Verificar se o hook já existe
if [ -f "$HOOK_FILE" ]; then
  echo -e "${RED}❌ Erro: Hook '$HOOK_NAME' já existe em $HOOK_FILE${NC}"
  exit 1
fi

# Criar diretório se não existir
echo -e "${BLUE}📁 Garantindo diretório: $HOOKS_DIR${NC}"
mkdir -p "$HOOKS_DIR"

# Criar arquivo do hook
echo -e "${BLUE}📝 Criando $HOOK_NAME.ts${NC}"
cat > "$HOOK_FILE" << EOF
import { useState, useEffect } from 'react';

/**
 * ${HOOK_NAME}
 * 
 * @description Breve descrição do que o hook faz
 * @example
 * \`\`\`tsx
 * const result = ${HOOK_NAME}();
 * \`\`\`
 */
export function ${HOOK_NAME}() {
  const [state, setState] = useState();

  useEffect(() => {
    // Sua lógica aqui
  }, []);

  return state;
}
EOF

# Criar arquivo de testes
echo -e "${BLUE}🧪 Criando ${HOOK_NAME}.test.ts${NC}"
cat > "$HOOKS_DIR/${HOOK_NAME}.test.ts" << EOF
import { describe, it, expect } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { ${HOOK_NAME} } from './${HOOK_NAME}';

describe('${HOOK_NAME}', () => {
  it('should initialize correctly', () => {
    const { result } = renderHook(() => ${HOOK_NAME}());
    expect(result.current).toBeDefined();
  });

  it('should handle updates', () => {
    const { result } = renderHook(() => ${HOOK_NAME}());
    
    act(() => {
      // Teste suas atualizações aqui
    });

    // Adicione suas asserções
  });
});
EOF

# Atualizar index.ts de hooks (ou criar se não existir)
INDEX_FILE="$HOOKS_DIR/index.ts"
if [ -f "$INDEX_FILE" ]; then
  echo -e "${BLUE}📝 Atualizando $INDEX_FILE${NC}"
  echo "export { ${HOOK_NAME} } from './${HOOK_NAME}';" >> "$INDEX_FILE"
else
  echo -e "${BLUE}📝 Criando $INDEX_FILE${NC}"
  echo "export { ${HOOK_NAME} } from './${HOOK_NAME}';" > "$INDEX_FILE"
fi

echo ""
echo -e "${GREEN}✅ Hook '$HOOK_NAME' criado com sucesso!${NC}"
echo -e "${GREEN}📍 Localização: $HOOK_FILE${NC}"
echo ""
echo -e "${YELLOW}Arquivos criados:${NC}"
echo "  ├─ $HOOK_NAME.ts"
echo "  ├─ ${HOOK_NAME}.test.ts"
echo "  └─ index.ts (atualizado)"
echo ""
echo -e "${BLUE}💡 Próximos passos:${NC}"
echo "  1. Implemente a lógica do hook em $HOOK_FILE"
echo "  2. Adicione testes em $HOOKS_DIR/${HOOK_NAME}.test.ts"
echo "  3. Use o hook em seus componentes:"
echo ""
echo -e "${YELLOW}     import { ${HOOK_NAME} } from '@/hooks';${NC}"
echo -e "${YELLOW}     const result = ${HOOK_NAME}();${NC}"
echo ""
