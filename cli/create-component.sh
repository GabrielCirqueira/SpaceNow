#!/bin/bash

# =============================================================================
# Script: create-component.sh
# Descrição: Cria um novo componente React com TypeScript e estrutura padrão
# Uso: ./cli/create-component.sh <ComponentName> [path]
# Exemplo: ./cli/create-component.sh Button src/components
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
  echo -e "${BLUE}  📦 Criador de Componentes React${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "${YELLOW}Uso:${NC}"
  echo "  ./cli/create-component.sh <ComponentName> [path]"
  echo ""
  echo -e "${YELLOW}Argumentos:${NC}"
  echo "  ComponentName  Nome do componente (PascalCase)"
  echo "  path           Caminho onde criar (padrão: src/components)"
  echo ""
  echo -e "${YELLOW}Exemplos:${NC}"
  echo "  ./cli/create-component.sh Button"
  echo "  ./cli/create-component.sh Card src/components/ui"
  echo "  ./cli/create-component.sh UserProfile src/features/user/components"
  echo ""
}

# Validar argumentos
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  show_help
  exit 0
fi

COMPONENT_NAME=$1
BASE_PATH=${2:-"src/components"}
COMPONENT_DIR="$BASE_PATH/$COMPONENT_NAME"

# Validar nome do componente (PascalCase)
if [[ ! $COMPONENT_NAME =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
  echo -e "${RED}❌ Erro: Nome do componente deve estar em PascalCase (ex: MyComponent)${NC}"
  exit 1
fi

# Verificar se o componente já existe
if [ -d "$COMPONENT_DIR" ]; then
  echo -e "${RED}❌ Erro: Componente '$COMPONENT_NAME' já existe em $COMPONENT_DIR${NC}"
  exit 1
fi

# Criar diretório
echo -e "${BLUE}📁 Criando diretório: $COMPONENT_DIR${NC}"
mkdir -p "$COMPONENT_DIR"

# Criar arquivo do componente
echo -e "${BLUE}📝 Criando $COMPONENT_NAME.tsx${NC}"
cat > "$COMPONENT_DIR/$COMPONENT_NAME.tsx" << EOF
import { forwardRef } from 'react';
import { cn } from '@shadcn/lib/utils';

export interface ${COMPONENT_NAME}Props extends React.HTMLAttributes<HTMLDivElement> {
  /** Adicione suas props customizadas aqui */
}

export const ${COMPONENT_NAME} = forwardRef<HTMLDivElement, ${COMPONENT_NAME}Props>(
  ({ className, children, ...props }, ref) => {
    return (
      <div ref={ref} className={cn('', className)} {...props}>
        {children}
      </div>
    );
  }
);

${COMPONENT_NAME}.displayName = '${COMPONENT_NAME}';
EOF

# Criar arquivo de tipos (se necessário)
echo -e "${BLUE}📝 Criando types.ts${NC}"
cat > "$COMPONENT_DIR/types.ts" << EOF
export interface ${COMPONENT_NAME}Props extends React.HTMLAttributes<HTMLDivElement> {
  /** Adicione suas props customizadas aqui */
}
EOF

# Criar arquivo index para exportação
echo -e "${BLUE}📝 Criando index.ts${NC}"
cat > "$COMPONENT_DIR/index.ts" << EOF
export { ${COMPONENT_NAME} } from './${COMPONENT_NAME}';
export type { ${COMPONENT_NAME}Props } from './types';
EOF

# Criar arquivo de testes (opcional)
echo -e "${BLUE}🧪 Criando ${COMPONENT_NAME}.test.tsx${NC}"
cat > "$COMPONENT_DIR/${COMPONENT_NAME}.test.tsx" << EOF
import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { ${COMPONENT_NAME} } from './${COMPONENT_NAME}';

describe('${COMPONENT_NAME}', () => {
  it('should render children correctly', () => {
    render(<${COMPONENT_NAME}>Test Content</${COMPONENT_NAME}>);
    expect(screen.getByText('Test Content')).toBeInTheDocument();
  });

  it('should apply custom className', () => {
    const { container } = render(
      <${COMPONENT_NAME} className="custom-class">Content</${COMPONENT_NAME}>
    );
    expect(container.firstChild).toHaveClass('custom-class');
  });
});
EOF

# Criar README do componente
echo -e "${BLUE}📄 Criando README.md${NC}"
cat > "$COMPONENT_DIR/README.md" << EOF
# ${COMPONENT_NAME}

## Descrição
Breve descrição do componente ${COMPONENT_NAME}.

## Uso

\`\`\`tsx
import { ${COMPONENT_NAME} } from '@/components/${COMPONENT_NAME}';

function Example() {
  return (
    <${COMPONENT_NAME}>
      Conteúdo aqui
    </${COMPONENT_NAME}>
  );
}
\`\`\`

## Props

| Prop | Tipo | Padrão | Descrição |
|------|------|--------|-----------|
| className | string | - | Classes CSS adicionais |
| children | ReactNode | - | Conteúdo do componente |

## Exemplos

### Exemplo Básico
\`\`\`tsx
<${COMPONENT_NAME}>
  Hello World
</${COMPONENT_NAME}>
\`\`\`

### Com Classes Customizadas
\`\`\`tsx
<${COMPONENT_NAME} className="custom-styles">
  Conteúdo estilizado
</${COMPONENT_NAME}>
\`\`\`
EOF

echo ""
echo -e "${GREEN}✅ Componente '$COMPONENT_NAME' criado com sucesso!${NC}"
echo -e "${GREEN}📍 Localização: $COMPONENT_DIR${NC}"
echo ""
echo -e "${YELLOW}Arquivos criados:${NC}"
echo "  ├─ $COMPONENT_NAME.tsx"
echo "  ├─ types.ts"
echo "  ├─ index.ts"
echo "  ├─ ${COMPONENT_NAME}.test.tsx"
echo "  └─ README.md"
echo ""
echo -e "${BLUE}💡 Próximos passos:${NC}"
echo "  1. Edite $COMPONENT_DIR/$COMPONENT_NAME.tsx"
echo "  2. Adicione suas props em $COMPONENT_DIR/types.ts"
echo "  3. Implemente os testes em $COMPONENT_DIR/${COMPONENT_NAME}.test.tsx"
echo "  4. Documente o uso em $COMPONENT_DIR/README.md"
echo ""
