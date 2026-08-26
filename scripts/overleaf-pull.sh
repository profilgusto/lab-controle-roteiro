#!/usr/bin/env bash
# Reintegra na pasta local o que os coautores editaram no Overleaf.
#
# Uso:  ./scripts/overleaf-pull.sh [caminho/do/zip]
#
# No Overleaf: Menu -> Download -> "Source" (baixa um .zip com os fontes).
# Sem argumento, o script pega o .zip mais recente em ~/Downloads.
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

ZIP="${1:-}"
if [[ -z "$ZIP" ]]; then
  ZIP="$(ls -t "$HOME/Downloads"/*.zip 2>/dev/null | head -1 || true)"
  [[ -n "$ZIP" ]] || { echo "ERRO: nenhum .zip em ~/Downloads. Passe o caminho."; exit 1; }
  echo "Usando o zip mais recente: $ZIP"
fi
[[ -f "$ZIP" ]] || { echo "ERRO: arquivo nao encontrado: $ZIP"; exit 1; }

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERRO: ha alteracoes nao commitadas."
  echo "      Commite ou guarde (git stash) antes, para que o diff mostre"
  echo "      apenas o que veio do Overleaf."
  git status --short
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
unzip -q "$ZIP" -d "$TMP"

# Se o zip tiver uma unica pasta raiz, entra nela.
# (evita mapfile, que nao existe no bash 3.2 do macOS)
n_itens=$(ls -A "$TMP" | wc -l | tr -d ' ')
primeiro=$(ls -A "$TMP" | head -1)
if [[ "$n_itens" -eq 1 && -d "$TMP/$primeiro" ]]; then
  TMP="$TMP/$primeiro"
fi

# Copia por cima, sem apagar nada e sem tocar no .git.
rsync -a --exclude '.git/' --exclude '.gitignore' --exclude '.gitattributes' \
      "$TMP"/ "$RAIZ"/

echo
echo "=== Arquivos que existem aqui mas NAO no Overleaf ==="
echo "(possiveis remocoes feitas pelos coautores -- apague na mao se for o caso)"
while IFS= read -r f; do
  case "$f" in _refs/*|scripts/*|Makefile|.gitattributes) continue;; esac
  [[ -e "$TMP/$f" ]] || echo "  $f"
done < <(git ls-files)

echo
echo "=== O que mudou ==="
git status --short
echo
echo "Revise com 'git diff'. Se estiver bom:"
echo "  git commit -am \"Edicoes dos coautores vindas do Overleaf\""
