
#!/usr/bin/env bash
set -euo pipefail

# clean-shadcn.sh
# ----------------
# Objetivo:
#  - Detectar quais componentes do pacote "shadcn" (localizados em
#    `src/shadcn/components/ui/*`) estão sendo efetivamente usados no código
#    (importados como `@shadcn/<component>`).
#  - Identificar os componentes que NÃO são referenciados em nenhum arquivo
#    dentro de `src/` e movê-los para um backup (em vez de apagar direto) quando
#    o usuário confirmar.
#
# Por que mover em vez de apagar?
#  - Remoções permanentes podem ser perigosas. O script cria um backup com
#    timestamp em `.shadcn-backup/` para permitir restauração.
#
# Visão geral da lógica (passo a passo):
# 1) Encontrar todas as importações que usam o alias `@shadcn/` nos arquivos
#    dentro de `src/`. Exemplo de import a ser detectado:
#      import { Button } from "@shadcn/button"
#    Para isso usamos uma busca por regex que captura o primeiro segmento após
#    `@shadcn/`, ou seja: `button`.
#
# 2) Listar todos os componentes (nomes) presentes em
#    `src/shadcn/components/ui/` — cada arquivo corresponde a um componente
#    (por exemplo `button.tsx` -> componente `button`).
#
# 3) Comparar as duas listas: as entradas que existem na pasta mas não na lista
#    de usados são consideradas candidatas a remoção.
#
# 4) Mostrar ao usuário um resumo (quantidades, listas) e aguardar confirmação.
#    - Por padrão o script roda em `--dry-run` (não remove nada), apenas mostra
#      o que seria removido.
#    - Passe `--yes` para aplicar as remoções (mover arquivos para backup).
#    - Há também `--keep <pattern>` para proteger componentes por padrão.
#
# 5) Se confirmado, mover os arquivos não usados para
#    `.shadcn-backup/<YYYYMMDD_HHMMSS>/components/ui/` mantendo o nome.

# Uso:
#  ./scripts/clean-shadcn.sh         # dry-run (padrão)
#  ./scripts/clean-shadcn.sh --yes   # aplica remoção (move para backup)
#  ./scripts/clean-shadcn.sh --help  # exibe ajuda
#  ./scripts/clean-shadcn.sh --keep button --yes
#
# Observações/limitações:
#  - Detecta apenas importações estáticas com o alias `@shadcn/*`.
#  - Não tenta interpretar imports dinâmicos ou strings concatenadas.
#  - Não altera arquivos que importem sub-paths (ex: `@shadcn/button/sub`),
#    mas o componente principal `button` ainda será detectado.
#  - Recomenda-se executar primeiro em dry-run, revisar a lista e então executar
#    com `--yes`.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/src"
SHADCN_UI_DIR="$SRC_DIR/shadcn/components/ui"
BACKUP_DIR="$ROOT_DIR/.backup-components"

DRY_RUN=true
FORCE=false
VERBOSE=false
KEEP_PATTERNS=()

usage() {
	cat <<-EOF
Usage: ${0##*/} [--yes] [--dry-run] [--keep PATTERN] [--verbose]

Options:
	--yes         Aplicar remoção (mover arquivos). Se omitido, roda em dry-run.
	--dry-run     Mostrar o que seria removido (padrão).
	--keep PAT    Proteger componentes cujo nome corresponde ao padrão (pode ser usado várias vezes).
	--verbose     Mostrar logs verbosos.
	--help        Mostrar esta ajuda.
EOF
}

# parse args
while [[ ${#@} -gt 0 ]]; do
	case "$1" in
		--yes)
			DRY_RUN=false; FORCE=true; shift;;
		--dry-run)
			DRY_RUN=true; shift;;
		--keep)
			shift; KEEP_PATTERNS+=("$1"); shift;;
		--verbose)
			VERBOSE=true; shift;;
		--help)
			usage; exit 0;;
		*)
			echo "Unknown arg: $1"; usage; exit 1;;
	esac
done

if [[ ! -d "$SHADCN_UI_DIR" ]]; then
	echo "Diretório de componentes shadcn não encontrado: $SHADCN_UI_DIR"
	exit 1
fi

echo "[clean-shadcn] scanning project under: $SRC_DIR"

# 1) Collect used component names by scanning imports like @shadcn/<name>
# Exclude files under the local shadcn directory itself so we only detect usage
# from the application code (not internal shadcn component-to-component imports).
TMP_USED=$(mktemp)
grep -R --binary-files=without-match --exclude-dir=shadcn -hPo "@shadcn/\K[A-Za-z0-9_-]+" "$SRC_DIR" | sort -u > "$TMP_USED" || true

# 2) Collect available component files in the shadcn UI folder
TMP_AVAILABLE=$(mktemp)
find "$SHADCN_UI_DIR" -maxdepth 1 -type f \( -name '*.tsx' -o -name '*.ts' -o -name '*.jsx' -o -name '*.js' \) -printf '%f\n' \
	| sed -E 's/\.[^.]+$//' | sort -u > "$TMP_AVAILABLE"

echo "Used components (detected):"
cat "$TMP_USED" || true
echo
echo "Available components (in $SHADCN_UI_DIR):"
cat "$TMP_AVAILABLE" || true
echo

# 3) Compute unused = available - used
TMP_UNUSED=$(mktemp)
comm -23 <(cat "$TMP_AVAILABLE") <(cat "$TMP_USED") | sort -u > "$TMP_UNUSED" || true

# apply keep patterns
if [[ ${#KEEP_PATTERNS[@]} -gt 0 ]]; then
	TMP_FILTERED=$(mktemp)
	cp "$TMP_UNUSED" "$TMP_FILTERED"
	for pat in "${KEEP_PATTERNS[@]}"; do
		# remove any matching pattern from the list
		grep -v -E "$pat" "$TMP_FILTERED" > "$TMP_UNUSED" || true
		mv "$TMP_UNUSED" "$TMP_FILTERED"
	done
	mv "$TMP_FILTERED" "$TMP_UNUSED"
fi

echo "Candidates para remoção (não usados):"
cat "$TMP_UNUSED" || true
echo

COUNT_UNUSED=$(wc -l < "$TMP_UNUSED" | tr -d ' ')
if [[ "$COUNT_UNUSED" -eq 0 ]]; then
	echo "Nenhum componente não utilizado encontrado. Nada a fazer."
	rm -f "$TMP_USED" "$TMP_AVAILABLE" "$TMP_UNUSED"
	exit 0
fi

if $DRY_RUN; then
	echo "DRY RUN: nenhum arquivo será movido. Para aplicar, execute com --yes."
	rm -f "$TMP_USED" "$TMP_AVAILABLE" "$TMP_UNUSED"
	exit 0
fi

# 4) perform backup + move
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEST="$BACKUP_DIR/$TIMESTAMP/components/ui"
mkdir -p "$DEST"

echo "Movendo $COUNT_UNUSED arquivos para backup: $DEST"

while read -r comp; do
	# find file matching this component (preserve extension)
	file=$(find "$SHADCN_UI_DIR" -maxdepth 1 -type f -name "$comp.*" | head -n1 || true)
	if [[ -z "$file" ]]; then
		echo "[warning] arquivo para componente '$comp' não encontrado; pulando"
		continue
	fi
	if [[ $VERBOSE == true ]]; then
		echo "movendo: $file -> $DEST/"
	fi
	mv "$file" "$DEST/" || { echo "falha ao mover $file"; exit 1; }
done < "$TMP_UNUSED"

echo "Movimentos concluídos. Backup criado em: $DEST"

# cleanup
rm -f "$TMP_USED" "$TMP_AVAILABLE" "$TMP_UNUSED"

echo "Done."
