# Template LaTeX — Guia de Aulas Práticas

Template que reproduz o design do *Guia de Aulas Práticas* (UFSJ / Campus Alto
Paraopeba) usado como referência (`_refs/guia-aulas-praticas-edgar.pdf`): capa
institucional, faixa "Aula N + título" em cinza com o brasão, campos rotulados
(Objetivos / Lista de material), roteiros numerados, tabelas de preenchimento com
cabeçalho cinza, apêndices com selo "Apêndice A/B" e rodapé `Pág. N | total`.

## Estrutura

```
main.tex                      dados do guia + ordem das seções
guiapratico.cls               a classe: todo o design vive aqui
secoes/intro.tex              texto de abertura
aulas/aula-01/aula.tex        uma pasta por aula
aulas/aula-01/img/            figuras daquela aula
aulas/aula-01/src/            fontes incluídos com \codigoarquivo (.py, .m, .ino, ...)
aulas/aula-02/aula.tex        esqueleto mínimo, para copiar
apendices/apendice-a/apendice.tex   normas do laboratório
apendices/apendice-b/apendice.tex   roteiro dos relatórios
figuras/ufsj-logo.pdf         brasão institucional (caminho fixado no .cls)
referencias.bib               base bibliográfica (ABNT NBR 6023:2018)
```

## Compilação

```sh
latexmk -pdf main.tex     # duas passadas: o rodapé precisa do total de páginas
latexmk -c                # limpa arquivos auxiliares
```

O `latexmk` chama o **biber** sozinho quando há citações — não é preciso rodar
nada à parte. Se as referências saírem vazias ou como `[?]`, apague os auxiliares
(`latexmk -C`) e recompile.

Requer TeX Live/MacTeX completo (usa `dejavu`, `tgtermes`, `tabularray`,
`enumitem`, `fancyhdr`, `lastpage`, `caption`, `needspace`, `biblatex`,
`biblatex-abnt`, `csquotes`, `listings`).

## Fontes

O original usa Verdana (títulos e corpo) e Times (nome da universidade na capa).
Por padrão a classe usa **DejaVu Sans**, substituta livre e metricamente próxima da
Verdana, e **TeX Gyre Termes** no lugar da Times — compila com `pdflatex`.

Para usar a Verdana real, compile com `lualatex` (ou `xelatex`) e passe a opção:

```latex
\documentclass[verdana]{guiapratico}
```

## Comandos da classe

### Dados (no preâmbulo do `main.tex`)

`\universidade` · `\subtitulos` · `\titulo` · `\unidadecurricular` · `\cursos` ·
`\professor` · `\arquivo` · `\datadoc` · `\revisao` · `\localano`

O brasão **não** entra aqui: ele pertence à classe, não ao documento. O caminho está
fixado no `.cls` (`\guia@def{logo}{...}`) e vale para a capa e para a faixa das
aulas. Para adaptar a classe a outra instituição, troque-o lá; para uma exceção
pontual num documento, `\logo{outro-arquivo.pdf}` continua funcionando.

No corpo do texto, reaproveite os valores com `\nomeunidade`, `\nomeprofessor`,
`\nomecursos`, `\nomearquivo`.

**Professor ou professores.** `\professor` aceita um nome ou vários, separados por
vírgula. Com mais de um, o rótulo vira **Professores:** sozinho:

```latex
\professor{Edgar Campos Furtado}                              % -> Professor:
\professor{Edgar Campos Furtado, Filipe Augusto Santos Rocha} % -> Professores:
```

Os nomes saem um por linha. Para os pôr na mesma linha, redefina o separador:

```latex
\renewcommand{\guiaprofsep}{, }
```

Um nome que contenha vírgula precisa vir entre chaves, senão vira dois nomes:
`\professor{{Fulano de Tal, Jr.}, Beltrana de Tal}`.

**Campos opcionais.** Um campo vazio some da capa junto com o seu rótulo — basta
não declará-lo, ou declará-lo vazio:

```latex
\arquivo{}     % a linha "Arquivo:" não é impressa
```

Se todos os campos de um grupo ficarem vazios, o grupo inteiro desaparece, com o
espaço vertical acima dele. Os grupos são: (1) Unidade Curricular + Cursos,
(2) Professor, (3) Arquivo + Data + Revisão.

Para acrescentar um campo próprio, edite `\maketitle` no `.cls` e use `\campocapa`,
que já traz o mesmo comportamento:

```latex
\campocapa{Semestre:}{\guia@semestre}
```

### Estrutura

| Comando | Efeito |
|---|---|
| `\maketitle` | capa institucional |
| `\sumario` | sumário do documento (aulas e apêndices), em página própria |
| `\aula{Título}` | nova página com a faixa "Aula N"; raiz da numeração (`N.1`, figuras `N.1`) |
| `\apendice{Título}` | nova página com o selo "Apêndice A/B/…"; raiz da numeração (`A.1`) |
| `\section{Título}` | seção numerada dentro da aula/apêndice — `1.1`, `A.1` |
| `\subsection{Título}` | subseção — `1.1.1` |
| `\subsubsection{Título}` | sub-subseção — `1.1.1.1` |
| `\secaoguia{Título}` | título de bloco em caixa alta, **sem** número e fora do sumário |
| `\subtituloguia{Texto}` | subtítulo indentado em negrito, **sem** número e fora do sumário |
| `\referencias` | lista de referências ABNT, em página nova |

#### Hierarquia e sumário

A aula (ou o apêndice) faz o papel de *capítulo*; abaixo dela valem os comandos
padrão do LaTeX:

```
\aula{Portas Lógicas}          ->  Aula 1          |  \apendice{Normas}  ->  Apêndice A
  \section{...}                ->  1.1             |    \section{...}    ->  A.1
    \subsection{...}           ->  1.1.1           |      \subsection{}  ->  A.1.1
      \subsubsection{...}      ->  1.1.1.1         |
```

Os contadores de seção, figura, tabela, equação e código são zerados a cada
`\aula`/`\apendice`, e a numeração leva sempre o número da aula ou a letra do
apêndice como prefixo (`Figura 1.1`, `Figura A.1`, `Código 2.3`).

O sumário lista apenas o nível de topo — aulas, apêndices e referências. As
seções são numeradas no corpo do texto, mas não aparecem nele; para incluí-las,
suba a profundidade no preâmbulo do `main.tex`:

```latex
\setcounter{tocdepth}{1}   % + \section     (1.1)
\setcounter{tocdepth}{2}   % + \subsection  (1.1.1)
\setcounter{tocdepth}{3}   % + \subsubsection
```

Os blocos não numerados (`\introducao`, `\pratica`, `\pesquisa`, `\secaoguia`,
`\subtituloguia`) continuam disponíveis e nunca entram no sumário — os dois
sistemas podem ser misturados no mesmo texto.

Como as seções são numeradas de verdade, elas aceitam `\label`/`\ref`:

```latex
\section{Montagem do circuito}\label{sec:montagem}
... conforme a Seção~\ref{sec:montagem} ...
```

Para figuras e equações existem chamadas prontas, que já escrevem o nome junto
do número (ligados por espaço inquebrável) e ficam clicáveis:

```latex
\begin{figure}[H]
  \centering
  \includefigure{circuito.png}
  \caption{Circuito da prática.}
  \label{fig:circuito}      % o \label vem DEPOIS do \caption
\end{figure}

\begin{equation}\label{eq:pid}
  u(t) = K_p\,e(t)
\end{equation}

Monte o circuito da \rfig{fig:circuito} e aplique a \req{eq:pid}.
% -> "Monte o circuito da Figura 1.2 e aplique a Equação (1.1)."
```

Como `\figuraguia` não tem onde encaixar o rótulo, uma figura que precise ser
referenciada deve ser montada no ambiente `figure`, como acima.

Se o título da aula/apêndice for longo ou contiver `\\`, passe um título curto
para o sumário no argumento opcional:

```latex
\apendice[Normas de Funcionamento do Laboratório]%
         {Normas de Funcionamento do Laboratório\\ de Sistemas Digitais e Microprocessadores}
```

Para trocar o título do sumário: `\sumario[Índice]`. `tocdepth` controla o que
entra no sumário (padrão `0`, só o nível de topo) e `secnumdepth`, até onde se
numera no texto (padrão `3`).

### Dentro de uma aula

| Comando | Efeito |
|---|---|
| `\objetivos{\item … \item …}` | campo "Objetivos:" com marcadores |
| `\objetivo{texto}` | versão de objetivo único |
| `\listamaterial{texto}` | campo "Lista de material:" |
| `\campo{Rótulo:}{conteúdo}` | campo rotulado genérico |
| `\introducao` | rótulo "Introdução:" |
| `\pratica` / `\pesquisa` | títulos `PRÁTICA:` (à esquerda) e `PESQUISA` (centrado) |
| `\obs{texto}` | parágrafo iniciado por **OBS --** |
| `roteiro` (ambiente) | itens numerados `1 – …`, com um nível de subitens `1.1 – …` |
| `normas` (ambiente) | numeração romana das normas (`\begin{normas}[I]`, `\norma{TÍTULO}`) |
| `tabelaguia` (ambiente) | tabela com cabeçalho cinza e fios pretos |
| `\vazio` | dá altura a uma célula em branco, para preenchimento à mão |
| `\figuraguia[largura]{arquivo}{legenda}` | figura centrada com legenda `Figura N.M:` |
| `\rfig{rotulo}` / `\req{rotulo}` | chamada no texto: `Figura N.M` e `Equação (N.M)` |
| `codigo` e atalhos (ambientes) | bloco de código-fonte com realce e legenda `Código N.M:` |
| `\codigoarquivo[opções]{arquivo}` | inclui um fonte externo (`.py`, `.m`, `.ino`, …) |
| `\cd{trecho}` | código curto no meio do texto |
| `\sw{…}` | termo estrangeiro/software em itálico |

### Ajustes de aparência

Redefina no preâmbulo, depois do `\documentclass`:

```latex
\definecolor{guiavinho}{HTML}{800000}      % "Aula", números, títulos de apêndice
\definecolor{guiacinza}{HTML}{E6E6E6}      % faixa e cabeçalho de tabelas
\definecolor{guiacinzaescuro}{HTML}{BFBFBF}% selo dos apêndices
\setlength{\guiarotulolargura}{4.0cm}      % largura da coluna de rótulos
\renewcommand{\guiatitulonivel}{0.5}       % altura do título na capa
\renewcommand{\guiacamposnivel}{0.75}      % altura de Unidade/Cursos/Professor
\setlength{\guiarevrecuo}{1.2cm}           % folga entre Data/Revisão e o pé
\renewcommand{\guiacapafonte}{\fontsize{14}{19}\selectfont}  % Unidade/Cursos/Professor
\renewcommand{\guiacapafontepe}{\normalsize}                 % Arquivo/Data/Revisão
\setlength{\guiafaixaaltura}{1.55cm}       % altura da faixa de título
\renewcommand{\aulanome}{Prática}          % troca a palavra "Aula"
```

## Blocos de código

Listagens de código-fonte com realce de sintaxe, numeração de linhas e legenda
`Código N.M:` — numeradas por aula, como as figuras. Implementadas com o pacote
`listings`, que compila com `pdflatex` sem `-shell-escape`.

```latex
\begin{codigopython}[caption={Controlador PID}, label={cod:pid}]
def passo(self, erro):
    self.integral += erro * self.dt
    return self.kp * erro + self.ki * self.integral
\end{codigopython}

Veja o Código~\ref{cod:pid}.
```

### Ambientes

| Ambiente | Linguagem |
|---|---|
| `codigo` | a que for passada em `language=` |
| `codigopython` | Python |
| `codigomatlab` | MATLAB/Octave (com as funções de controle: `tf`, `bode`, `feedback`, …) |
| `codigoc` / `codigocpp` | C / C++ |
| `codigoarduino` | C++ com a API do Arduino (`pinMode`, `analogRead`, `Serial`, …) |
| `codigovhdl` | VHDL |
| `codigobash` | shell/bash |
| `codigotexto` | sem realce — saída de terminal, dados, pseudocódigo |

Todos aceitam, no argumento opcional, qualquer chave do `listings`:

```latex
\begin{codigo}[language=Java, caption={...}, style=semnumeros, firstnumber=10]
```

As chaves mais úteis: `caption={...}` (legenda), `label={...}` (para `\ref`),
`style=semnumeros` (sem numeração de linhas, com o recuo ajustado),
`firstline`/`lastline` (recorta um
trecho), `escapeinside={(*}{*)}` (permite LaTeX dentro do código),
`basicstyle=\ttfamily\scriptsize` (código muito largo).

### Arquivo externo

Melhor que copiar e colar: o código fica num arquivo de verdade, que roda, e o
guia sempre mostra a versão atual.

```latex
\codigoarquivo[language=Python, caption={Ensaio ao degrau}]{aulas/aula-01/src/degrau.py}
\codigoarquivo[language=Matlab, firstline=10, lastline=25]{aulas/aula-01/src/planta.m}
```

Guarde os fontes em `aulas/aula-NN/src/` — o `Makefile` já refaz o PDF quando
eles mudam.

### Código no meio do texto

```latex
Chame \cd{step(sys)} para ver a resposta ao degrau.
```

Se o trecho tiver `%` ou chaves desbalanceadas, use delimitadores no lugar das
chaves: `\cd|a % b|`.

### Índice das listagens

`\listadecodigos` imprime a lista de todos os códigos do guia (opcionalmente com
outro título: `\listadecodigos[Programas]`).

### Aparência

Cores e fontes são redefiníveis no preâmbulo:

```latex
\definecolor{codigofundo}{HTML}{F7F7F5}       % fundo da caixa
\definecolor{codigomoldura}{HTML}{BFBFBF}     % fio da moldura
\definecolor{codigopalavra}{HTML}{800000}     % palavras reservadas
\definecolor{codigocomentario}{HTML}{6E7B6E}  % comentários
\definecolor{codigotexto}{HTML}{2E5D8C}       % cadeias de caracteres
\definecolor{codigolinha}{HTML}{9A9A9A}       % números de linha
\renewcommand{\guiacodigofonte}{\ttfamily\fontsize{8.5}{10.5}\selectfont}
\renewcommand{\guiacodigonum}{\ttfamily\fontsize{7}{9}\selectfont\color{codigolinha}}
\lstset{style=semnumeros}                      % muda o padrão de todas as listagens
```

Para um guia que vai ser impresso em preto e branco, a opção de classe
`codigopb` troca o realce por tons de cinza:

```latex
\documentclass[codigopb]{guiapratico}
```

Acentuação dentro das listagens funciona (comentários e cadeias em português);
linhas longas são quebradas automaticamente, com uma seta `↵` indicando a quebra.

## Citações e referências (ABNT)

Citações pela **NBR 10520:2023** e referências pela **NBR 6023:2018**, via
`biblatex-abnt` + `biber`. A classe já carrega e configura tudo; no documento
há três passos:

```latex
\bibliografia{referencias.bib}   % 1. no preâmbulo, junto dos demais dados
...
\cite{ogata2010}                 % 2. citar no texto
...
\referencias                     % 3. onde a lista deve ser impressa
```

`\referencias` abre página nova, imprime o título `REFERÊNCIAS` no estilo dos
demais blocos do guia e cria a entrada de sumário. Pela NBR 14724, ele vai
**depois das aulas e antes dos apêndices** — é onde o `main.tex` já o coloca.
Para outro título: `\referencias[Bibliografia recomendada]`.

### Comandos de citação

| Comando | Saída | Quando usar |
|---|---|---|
| `\cite{k}` | (OGATA, 2010) | citação indireta, autor entre parênteses |
| `\cite{k1,k2}` | (OGATA, 2010; NISE, 2017) | várias obras de uma vez |
| `\cite[p.~42]{k}` | (OGATA, 2010, p. 42) | citação direta, com a página |
| `\textcite{k}` | Ogata (2010) | autor como sujeito da frase |
| `\citeonline{k}` | Ogata (2010) | apelido do `\textcite`, como no abntex2 |
| `\apud{k1}{k2}` | (NISE, 2017 apud OGATA, 2010) | citação de citação |
| `\citeauthor{k}` / `\citeyear{k}` | (OGATA) / (2010) | só o autor ou só o ano |
| `\citeauthor*{k}` / `\citeyear*{k}` | OGATA / 2010 | idem, sem os parênteses |
| `\nocite{k}` | — | entra nas referências sem ser citada no texto |

A caixa alta dentro dos parênteses e a caixa normal fora deles são aplicadas
automaticamente, como pede a NBR 10520 — escreva sempre a chave, nunca o nome
formatado à mão.

### O arquivo `.bib`

Preencha só os campos; **nada** de caixa alta, negrito, itálico ou ponto final
manual — o estilo formata. `referencias.bib` já traz um exemplar de cada tipo
que costuma aparecer num guia de laboratório (livro, capítulo, artigo, trabalho
de evento, dissertação, norma técnica, *datasheet*, documento eletrônico); use-os
como molde.

```bibtex
@book{ogata2010,
  author    = {Katsuhiko Ogata},
  title     = {Engenharia de controle moderno},
  edition   = {5},                       % vira "5. ed."
  publisher = {Pearson Prentice Hall},
  location  = {São Paulo},
  year      = {2010},
}
```

Três armadilhas comuns:

- **autor institucional** vai entre chaves duplas, senão vira nome e sobrenome:
  `author = {{Associação Brasileira de Normas Técnicas}}`;
- **maiúsculas a preservar** vão entre chaves: `title = {Controle {PID}}`;
- **nome com vírgula** usa a forma `{Sobrenome, Nome}`.

Com mais de três autores, imprime-se o primeiro seguido de *et al.*, conforme a
NBR 6023:2018. Para listar todos, mude `maxnames` no `.cls`.

### Estilo das citações

Opção da classe, no `\documentclass`:

| Opção | Efeito |
|---|---|
| `citaralf` (padrão) | sistema autor-data: `(OGATA, 2010)` |
| `citarnum` | sistema numérico: `(4)`, na ordem alfabética das referências |
| `sembib` | não carrega o `biblatex`; use num guia sem citações |

```latex
\documentclass[citarnum]{guiapratico}
```

Com `sembib`, qualquer `\cite` para a compilação com uma mensagem explicando
que a opção precisa ser removida.

Outros ajustes ficam nas opções do `biblatex` dentro do `.cls`:
`giveninits=true` abrevia os prenomes (`SILVA, J. C.`), `sccite=true` usa
versalete em vez de caixa alta nas citações e `maxnames` controla o *et al.*

## Layout vertical da capa

Os blocos da capa são posicionados por **fração da altura do texto**, medida do
topo, e não por espaçamentos fixos — o título continua centrado mesmo que o
cabeçalho institucional ganhe ou perca linhas.

| Knob | Padrão | Efeito |
|---|---|---|
| `\guiatitulonivel` | `0.5` | centro do título (0.5 = meio da página) |
| `\guiacamposnivel` | `0.75` | centro do bloco Unidade/Cursos/Professor |
| `\guiarevrecuo` | `1.2cm` | folga entre Arquivo/Data/Revisão e o pé |

O valor é a posição do **centro** do bloco. Arquivo/Data/Revisão é ancorado no pé
(via `\vfill`), por isso é o único controlado por distância e não por fração.

## Nova aula em 4 passos

1. `cp -r aulas/aula-02 aulas/aula-03`
2. troque o título em `\aula{…}` (a numeração é automática);
3. escreva os blocos `\objetivos`, `\listamaterial`, `\introducao`, `\pratica`,
   `\pesquisa`;
4. acrescente `\input{aulas/aula-03/aula}` em `main.tex`.
