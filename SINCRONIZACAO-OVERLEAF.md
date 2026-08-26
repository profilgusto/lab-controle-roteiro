# Sincronização com o Overleaf

Este projeto é escrito **localmente** (com `git`) e revisado por coautores **no
Overleaf**. Como a conta do Overleaf é gratuita, não há Git bridge; a ponte é
feita por `.zip` nos dois sentidos, com dois scripts.

    ~/git-sources/roteiro-aulas-praticas   <-- pasta de trabalho local
                    |  push (zip de fontes)
                    v
              projeto no Overleaf          <-- coautores editam aqui
                    |  pull (Download > Source)
                    v
              volta para a pasta local, como um commit

## Primeira vez: criar o projeto no Overleaf

1. `./scripts/overleaf-push.sh` — gera `.overleaf/guia-aulas-praticas.zip`.
2. No Overleaf: **New Project → Upload Project** e escolha esse zip.
3. Abra o projeto e confirme em **Menu → Settings**:
   - *Main document*: `main.tex`
   - *Compiler*: **pdfLaTeX** (a classe usa `inputenc`/`fontenc`; só troque
     para LuaLaTeX/XeLaTeX se passar a usar `fontspec`)
   - Compile uma vez para conferir que a classe `guiapratico.cls` foi aceita.
4. **Share** → convide os coautores por e-mail (a conta gratuita permite
   convidar colaboradores; se estourar o limite, use o link "Anyone with the
   link can edit").

## Enviar seu trabalho para o Overleaf

    git commit -am "..."          # o zip é gerado a partir do último commit
    ./scripts/overleaf-push.sh

No Overleaf, arraste o `.zip` para a lista de arquivos do projeto (ou botão
**Upload**). Ele descompacta e **sobrescreve** os arquivos de mesmo nome.

> **Sempre faça o pull antes do push.** O push sobrescreve; se um coautor
> editou algo que ainda não veio para cá, o texto dele se perde.

## Trazer as edições dos coautores

1. No Overleaf: **Menu → Download → Source** (baixa um `.zip`).
2. Com a árvore local limpa (sem alterações pendentes):

       ./scripts/overleaf-pull.sh            # pega o zip mais novo em ~/Downloads
       ./scripts/overleaf-pull.sh ~/caminho/projeto.zip

3. O script copia por cima e mostra o que mudou. Revise e commite:

       git diff
       git commit -am "Edições dos coautores vindas do Overleaf"

O script **não apaga** arquivos: se os coautores removeram algo, ele lista
esses arquivos ao final para você decidir.

## O que não vai para o Overleaf

Definido em `.gitattributes` (`export-ignore`): `_refs/`, `scripts/`,
`Makefile`, `.gitignore`, `.gitattributes`. Saídas de compilação (`.aux`,
`.pdf`, `.bbl`…) ficam fora pelo `.gitignore` — o Overleaf gera as suas.

## Combinado com os coautores

Para reduzir conflito, o ideal é dividir por arquivo: cada aula vive em
`aulas/aula-NN/conteudo.tex`. Se cada um mexer na sua aula, o zip de ida e
volta nunca disputa a mesma linha.
