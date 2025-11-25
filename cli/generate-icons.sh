#!/bin/bash

# =============================================================================
# Script: generate-icons.sh
# Descrição: Lista todos os ícones disponíveis do lucide-react
# Uso: ./cli/generate-icons.sh [search_term]
# Exemplo: ./cli/generate-icons.sh user
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SEARCH_TERM=${1:-""}

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  🎨 Gerador de Referência de Ícones Lucide${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verificar se lucide-react está instalado
if [ ! -d "node_modules/lucide-react" ]; then
  echo -e "${RED}❌ Erro: lucide-react não está instalado${NC}"
  echo -e "${YELLOW}💡 Execute: npm install lucide-react${NC}"
  exit 1
fi

# Criar arquivo temporário com lista de ícones
ICONS_FILE="node_modules/lucide-react/dist/esm/icons/index.d.ts"
if [ ! -f "$ICONS_FILE" ]; then
  ICONS_FILE="node_modules/lucide-react/dist/index.d.ts"
fi

# Criar arquivo de referência
OUTPUT_FILE="ICONS_REFERENCE.md"

echo -e "${CYAN}📝 Gerando referência de ícones...${NC}"
echo ""

# Extrair nomes de ícones
cat > "$OUTPUT_FILE" << 'EOF'
# 🎨 Referência de Ícones Lucide React

Esta é uma referência rápida dos ícones disponíveis no projeto.

## 📖 Como Usar

```tsx
import { Icon } from '@shadcn/components/ui/icon';
import { Heart, Star, User } from 'lucide-react';

// Usando o componente Icon
<Icon icon={Heart} size={24} />

// Usando diretamente
<Heart size={24} />
```

## 🔍 Categorias de Ícones

EOF

# Popular categorias comuns
cat >> "$OUTPUT_FILE" << 'EOF'
### 👤 Usuário e Perfil
- User, UserPlus, UserMinus, UserCheck, UserX
- Users, UsersRound, UserCircle, UserSquare
- Contact, ContactRound

### 📝 Texto e Edição
- Edit, Edit2, Edit3, Pencil, PencilLine
- Type, Text, TextCursor, TextSelect
- AlignLeft, AlignCenter, AlignRight, AlignJustify

### 📁 Arquivos e Pastas
- File, FileText, FilePlus, FileMinus
- Folder, FolderOpen, FolderPlus, FolderMinus
- Download, Upload, FileDown, FileUp

### 🖼️ Mídia
- Image, ImagePlus, ImageMinus
- Video, Film, Camera
- Music, Mic, Volume, Volume2

### 💬 Comunicação
- Mail, MailOpen, Send
- MessageCircle, MessageSquare
- Phone, PhoneCall, PhoneMissed

### 🔔 Notificações
- Bell, BellOff, BellRing
- AlertCircle, AlertTriangle, AlertOctagon
- Info, HelpCircle

### ⚙️ Configurações e Sistema
- Settings, Settings2, Sliders
- Tool, Wrench, Cog
- Power, PowerOff

### 🎯 Navegação
- Home, Menu, MoreHorizontal, MoreVertical
- ChevronLeft, ChevronRight, ChevronUp, ChevronDown
- ArrowLeft, ArrowRight, ArrowUp, ArrowDown
- X, Plus, Minus, Check

### 🔒 Segurança
- Lock, LockOpen, Unlock
- Key, Shield, ShieldCheck
- Eye, EyeOff

### 💰 E-commerce
- ShoppingCart, ShoppingBag
- CreditCard, Wallet
- DollarSign, Tag, BadgePercent

### 📊 Gráficos e Dados
- BarChart, LineChart, PieChart
- TrendingUp, TrendingDown
- Activity, GitBranch

### 🗓️ Data e Tempo
- Calendar, CalendarDays, Clock
- Timer, Hourglass
- History

### 🌐 Social e Compartilhamento
- Share, Share2, Link, Link2
- Heart, Star, Bookmark
- ThumbsUp, ThumbsDown

### 🎨 Design
- Palette, Brush, Paintbrush
- Layout, Grid, Columns
- Square, Circle, Triangle

### 🔧 Desenvolvimento
- Code, Code2, Terminal
- GitBranch, GitCommit, GitMerge
- Bug, Database, Server

### ✨ Ações Comuns
- Copy, Cut, Paste
- Undo, Redo, RotateCcw, RotateCw
- Save, Trash, Trash2
- Maximize, Minimize, RefreshCcw

### 🌍 Localização
- MapPin, Map, Navigation
- Globe, Compass

### 📱 Dispositivos
- Smartphone, Tablet, Laptop
- Monitor, Tv, Watch

EOF

# Listar todos os ícones disponíveis
echo -e "${CYAN}📋 Listando ícones disponíveis...${NC}"

# Tentar extrair lista de ícones
if command -v node &> /dev/null; then
  node -e "
    try {
      const icons = require('lucide-react');
      const iconNames = Object.keys(icons)
        .filter(key => key !== 'default' && key !== 'createLucideIcon')
        .filter(key => typeof icons[key] === 'function' || typeof icons[key] === 'object')
        .sort();
      
      console.log('\n### 📚 Lista Completa (${iconNames.length} ícones)\n');
      
      let count = 0;
      let line = '';
      iconNames.forEach(name => {
        line += \`\\\`\${name}\\\`, \`;
        count++;
        if (count % 5 === 0) {
          console.log(line);
          line = '';
        }
      });
      if (line) console.log(line);
    } catch (e) {
      console.log('Não foi possível listar os ícones automaticamente.');
    }
  " >> "$OUTPUT_FILE" 2>/dev/null || echo "### 📚 Lista Completa" >> "$OUTPUT_FILE"
fi

# Adicionar exemplos de código
cat >> "$OUTPUT_FILE" << 'EOF'

## 💻 Exemplos de Código

### Exemplo 1: Botão com Ícone
```tsx
import { Icon } from '@shadcn/components/ui/icon';
import { Heart } from 'lucide-react';

<button className="flex items-center gap-2">
  <Icon icon={Heart} size={20} />
  <span>Curtir</span>
</button>
```

### Exemplo 2: Card com Ícone
```tsx
import { Icon } from '@shadcn/components/ui/icon';
import { CheckCircle } from 'lucide-react';

<div className="flex items-start gap-3">
  <Icon icon={CheckCircle} size={24} className="text-success-600" />
  <div>
    <h3>Sucesso!</h3>
    <p>Operação concluída com sucesso.</p>
  </div>
</div>
```

### Exemplo 3: Lista de Navegação
```tsx
import { Icon } from '@shadcn/components/ui/icon';
import { Home, Settings, User, HelpCircle } from 'lucide-react';

const menuItems = [
  { icon: Home, label: 'Início' },
  { icon: User, label: 'Perfil' },
  { icon: Settings, label: 'Configurações' },
  { icon: HelpCircle, label: 'Ajuda' },
];

<nav>
  {menuItems.map(item => (
    <a key={item.label} href="#" className="flex items-center gap-2">
      <Icon icon={item.icon} size={20} />
      <span>{item.label}</span>
    </a>
  ))}
</nav>
```

## 🔗 Links Úteis

- [Documentação Oficial Lucide](https://lucide.dev)
- [Pesquisar Ícones](https://lucide.dev/icons)
- [GitHub do Lucide React](https://github.com/lucide-icons/lucide)

---

**Gerado automaticamente em:** $(date)
EOF

echo -e "${GREEN}✅ Referência de ícones criada em: $OUTPUT_FILE${NC}"
echo ""

# Se houver termo de busca, filtrar
if [ -n "$SEARCH_TERM" ]; then
  echo -e "${CYAN}🔍 Procurando por: '$SEARCH_TERM'${NC}"
  echo ""
  grep -i "$SEARCH_TERM" "$OUTPUT_FILE" || echo -e "${YELLOW}Nenhum ícone encontrado com o termo '$SEARCH_TERM'${NC}"
  echo ""
fi

echo -e "${BLUE}💡 Dicas:${NC}"
echo "  • Veja o arquivo completo: cat $OUTPUT_FILE"
echo "  • Procurar ícone: ./cli/generate-icons.sh user"
echo "  • Todos os ícones: https://lucide.dev/icons"
echo ""
