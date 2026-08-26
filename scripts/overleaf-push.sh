#!/usr/bin/env bash
# Gera o .zip com os fontes do guia para subir no projeto do Overleaf.
#
# Uso:  ./scripts/overleaf-push.sh
#
# Depois: no Overleaf, abra o projeto -> botao "Upload" (ou arraste o .zip
# para a lista de arquivos). O Overleaf descompacta o zip e SOBRESCREVE os
# arquivos de mesmo nome. Faca um pull antes, para nao apagar edicao dos
# coautores que ainda nao esteja aqui.
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"
SAIDA="$RAIZ/.overleaf/guia-aulas-praticas.zip"
mkdir -p "$(dirname "$SAIDA")"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "AVISO: ha alteracoes nao commitadas. O zip usa o ultimo commit (HEAD)."
  echo "       Commite antes se quiser enviar o trabalho mais recente."
  git status --short
  read -r -p "Continuar mesmo assim? [s/N] " r
  [[ "$r" == [sS] ]] || exit 1
fi

rm -f "$SAIDA"
# git archive respeita o export-ignore do .gitattributes e ignora arquivos
# gerados (que ja estao no .gitignore).
git archive --format=zip -o "$SAIDA" HEAD

echo
echo "Zip pronto: $SAIDA"
unzip -l "$SAIDA" | tail -n +4 | head -30
echo
echo "Marcando este commit como o ultimo enviado ao Overleaf..."
git tag -f overleaf-enviado >/dev/null
open -R "$SAIDA" 2>/dev/null || true
