# Guia de escrita de conteúdo

Como *escrever* uma aula neste template. O `README.md` da raiz é a **referência
de comandos** (o que cada macro faz, quais opções aceita); este documento é o
**manual do autor**: onde pôr cada arquivo, em que ordem escrever, que
convenções de linguagem seguir e quais armadilhas evitar.

> Regra geral: o `.tex` da aula descreve **conteúdo**, nunca aparência. Se você
> se pegar escrevendo `\vspace`, `\textbf` num título, `\hspace` para alinhar ou
> `\newpage` para consertar uma quebra, pare — provavelmente existe um comando
> da classe para isso, ou o ajuste pertence ao `guiapratico.cls`.

---

## 1. Onde as coisas moram

```
main.tex                        metadados do guia + ordem das aulas
secoes/intro.tex                texto de abertura do guia
aulas/aula-NN/conteudo.tex      o texto da aula NN
aulas/aula-NN/img/              imagens SÓ dessa aula
aulas/aula-NN/src/              códigos-fonte SÓ dessa aula (.py, .m, .ino…)
apendices/apendice-X/conteudo.tex
figuras/                        imagens compartilhadas entre aulas
referencias.bib                 base bibliográfica única do guia
_references/                    documentação para quem escreve (este arquivo)
_refs/                          material de origem (PDF-modelo do guia)
```

Três decisões de arquivo que você tomará o tempo todo:

| Situação | Onde vai | Como chama |
|---|---|---|
| Imagem usada em **uma** aula | `aulas/aula-NN/img/` | `\figuraguia{arquivo.png}{legenda}` |
| Imagem usada em **várias** aulas | `figuras/` | `\figuraglobal{figuras/arquivo.pdf}{legenda}` |
| Código que o aluno vai rodar | `aulas/aula-NN/src/` | `\codigoarquivo[...]{aulas/aula-NN/src/x.py}` |

O caminho de `\figuraguia` é resolvido **relativo ao `.tex` que o chama**, não à
raiz — por isso se escreve só o nome do arquivo, e por isso mover a pasta da
aula inteira não quebra nada. Já `\figuraglobal` e `\codigoarquivo` recebem o
caminho **a partir da raiz** do projeto.

## 2. Criando uma aula nova

1. `cp -r aulas/aula-exemplo aulas/aula-03` (ou copie o esqueleto da §3);
2. limpe `img/` e `src/`, apague o conteúdo de exemplo;
3. escreva o `\aula{...}` — **não** numere à mão, a numeração é automática e
   vem da ordem dos `\input` no `main.tex`;
4. acrescente `\input{aulas/aula-03/conteudo}` no `main.tex`, no lugar certo da
   sequência;
5. `make` (ou `latexmk -pdf main.tex`).

Renumerar aulas = reordenar os `\input`. Nada mais. Se o texto de uma aula
menciona outra pelo número, use `\label`/`\ref` em vez de digitar "Aula 2".

## 3. Anatomia de uma aula

A ordem abaixo é a do guia de referência; siga-a salvo motivo forte.

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Aula 3 -- Resposta em frequência
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\aula[Resposta em frequência]{Resposta em Frequência de Sistemas de 1ª Ordem}

\objetivos{%
  \item levantar experimentalmente o diagrama de Bode de um filtro RC;
  \item comparar a curva medida com a resposta teórica.}

\listamaterial{1 osciloscópio digital; 1 gerador de funções; 2 resistores de 10 k$\Omega$;
  1 capacitor de 100 nF; cabos banana--jacaré.}

\campo{Duração:}{2 horas/aula (1h40min).}   % opcional

\introducao            % ou \section{Introdução}, ver §4

Texto teórico curto: o que o aluno precisa saber para executar a prática.

\pratica

\begin{roteiro}
  \item Monte o circuito da Figura~\ref{fig:rc}.
  \item ...
\end{roteiro}

\pesquisa

\begin{roteiro}
  \item Pergunta teórica a ser respondida antes/depois da aula.
\end{roteiro}
```

**O que cada bloco deve conter**

- **`\aula[curto]{Completo}`** — o título curto (opcional) é o que vai para o
  sumário; use-o sempre que o título tiver mais de ~40 caracteres ou contiver
  `\\`.
- **`\objetivos`** — verbos no infinitivo, um objetivo por `\item`, minúscula
  inicial, `;` no fim de cada e `.` no último. São os objetivos **do aluno**,
  não os do professor: "identificar", "medir", "comparar", não "apresentar".
- **`\listamaterial`** — texto corrido separado por `;`, com quantidade na
  frente: `1 osciloscópio digital; 2 resistores de 10 kΩ; …`. Um item por
  equipamento realmente necessário — a lista é usada pelo laboratorista.
- **`\introducao`** — a teoria **mínima** para executar a prática, não um
  capítulo de livro. Se precisar de mais de uma página, o excesso provavelmente
  é `\pesquisa` ou uma citação à bibliografia da disciplina.
- **`\pratica`** — o roteiro executável, em `roteiro`. Ver §5.
- **`\pesquisa`** — o que o aluno responde fora do laboratório. Também em
  `roteiro`.

Blocos vazios simplesmente não são escritos: `\campo` e `\objetivo` com
argumento em branco não imprimem nada, e um `\pesquisa` sem conteúdo deve ser
apagado, não deixado vazio.

## 4. Dois sistemas de títulos — quando usar cada um

| Comando | Numerado? | No sumário? | Use para |
|---|---|---|---|
| `\section` / `\subsection` / `\subsubsection` | sim (`3.1`, `3.1.1`) | só se `tocdepth` ≥ 1 | partes do texto que você vai **referenciar** (`\ref`) |
| `\secaoguia{...}` | não | não | divisórias visuais em caixa alta, no estilo de `REFERÊNCIAS` |
| `\subtituloguia{...}` | não | não | subtítulo curto em negrito dentro de um bloco |
| `\introducao` / `\pratica` / `\pesquisa` | não | não | os três blocos canônicos da aula |

Critério prático: **precisa citar depois? use `\section` com `\label`. Não
precisa? use `\subtituloguia`.** Misturar os dois no mesmo texto é esperado e
não é problema.

Rótulos: prefixe por tipo — `sec:`, `fig:`, `tab:`, `eq:`, `cod:` — e mantenha o
nome descritivo (`fig:bode-rc`, não `fig:1`). Referencie sempre com til:
`Figura~\ref{fig:bode-rc}`, `Seção~\ref{sec:montagem}`.

## 5. Escrevendo o roteiro

O roteiro é a parte que o aluno lê **com as mãos ocupadas**. Escreva-o como
instrução, não como narrativa.

- **um passo = uma ação verificável**; se um item tem dois verbos de ação
  ("monte e meça"), são dois itens;
- **imperativo**: "Monte", "Ajuste", "Registre", "Compare" — nunca "o aluno
  deverá montar";
- **valores explícitos**: `onda quadrada de 1 kHz, 5 V_pp` — nada de "uma
  frequência adequada";
- **subitens** (um nível só) para o detalhamento de um passo: ajustes de um
  mesmo instrumento, alíneas de uma mesma montagem;
- todo passo de medição aponta para **onde registrar**: "Registre na
  Tabela~\ref{tab:medidas}";
- avisos de segurança ou pegadinhas de montagem saem do roteiro e viram
  `\obs{...}` logo acima do passo em questão.

```latex
\begin{roteiro}
  \item Monte na protoboard o circuito da Figura~\ref{fig:rc}.
  \item Ajuste o gerador de funções:
    \begin{roteiro}
      \item onda senoidal, amplitude $2\,\text{V}_{pp}$;
      \item varie a frequência de 10 Hz a 100 kHz, uma década por vez.
    \end{roteiro}
  \item Registre na Tabela~\ref{tab:medidas} o ganho e a defasagem.
\end{roteiro}
```

## 6. Tabelas de preenchimento

A tabela que o aluno preenche à mão é o instrumento principal de coleta —
desenhe-a antes de escrever o roteiro, e o roteiro sai sozinho.

```latex
\begin{table}[H]
  \centering
  \caption{Medidas do ensaio --- preencher durante a prática.}
  \label{tab:medidas}
  \begin{tabelaguia}{colspec={cccc},width=0.85\textwidth}
    $f$ [Hz] & $V_{\text{ent}}$ [V] & $V_{\text{sai}}$ [V] & $\varphi$ [$^\circ$] \\
    10   & \vazio & & \\
    100  & \vazio & & \\
    1000 & \vazio & & \\
  \end{tabelaguia}
\end{table}
```

- a **primeira linha é sempre o cabeçalho** (sai em cinza e negrito
  automaticamente) — não repita `\textbf`;
- **unidade no cabeçalho, entre colchetes**, nunca em cada célula;
- `\vazio` na primeira célula de cada linha vazia dá altura de escrita à linha
  inteira — basta uma por linha;
- a legenda vem **antes** da tabela (`\caption` acima do `tabelaguia`) e o
  `\label` logo depois dela;
- `width=` em fração de `\textwidth`; use `X` no `colspec` para colunas de texto
  que devem esticar.

## 7. Figuras

```latex
\figuraguia[0.8\textwidth]{circuito-rc.png}{Circuito RC do ensaio.}
```

Isso basta em 90% dos casos. **Mas `\figuraguia` não aceita `\label`** — para
uma figura referenciável, monte o float à mão:

```latex
\begin{figure}[H]
  \centering
  \includefigure[0.6\textwidth]{circuito-rc.png}
  \caption{Circuito RC do ensaio.}
  \label{fig:rc}
\end{figure}
```

Convenções:

- prefira **PDF/SVG-exportado-em-PDF** para diagramas e esquemáticos (escala
  sem serrilhado); PNG só para capturas de tela e fotos;
- largura em fração de `\textwidth` (`0.6\textwidth`), nunca em cm;
- legenda descreve **o que é**, terminada em ponto; a explicação vai no texto;
- toda figura deve ser citada no texto antes de aparecer.

## 8. Código

Duas formas, e uma delas é quase sempre a certa:

- **`\codigoarquivo`** — o fonte vive em `src/`, roda de verdade, e o guia
  mostra sempre a versão atual. Use isto para qualquer código que o aluno vá
  executar. `firstline`/`lastline` recortam o trecho relevante;
- **ambientes `codigopython`, `codigomatlab`, `codigoarduino`, …** — para
  trechos curtos e ilustrativos que não existem como arquivo.

```latex
\codigoarquivo[language=Python, firstline=14, lastline=21,
  caption={Identificação pelo método dos dois pontos.},
  label={cod:identifica}]{aulas/aula-03/src/degrau.py}
```

- sempre `caption=` e, se for citado, `label={cod:...}`;
- **comentários do código em português**, como o resto do guia (acentuação
  funciona dentro das listagens);
- saída de terminal e dados vão em `codigotexto` com `style=semnumeros` —
  numerar linhas de uma saída não faz sentido;
- código muito largo: `basicstyle=\ttfamily\scriptsize`, ou melhor, quebre as
  linhas no próprio fonte.

## 9. Citações e bibliografia

Regra única: **nunca escreva um nome de autor formatado à mão**. Sempre a chave.

| Você quer dizer | Escreva |
|---|---|
| …conforme (OGATA, 2010) | `\cite{ogata2010}` |
| Ogata (2010) demonstra que… | `\textcite{ogata2010}` |
| citação direta, com página | `\cite[p.~42]{ogata2010}` |
| citação de citação | `\apud{astrom2004}{ogata2010}` |

No `referencias.bib`, preencha **só os campos** — sem caixa alta, negrito,
itálico ou ponto final manual; o estilo ABNT formata. As três armadilhas:

```bibtex
author = {{Associação Brasileira de Normas Técnicas}}  % autor institucional: chaves duplas
title  = {Controle {PID}}                              % siglas a preservar: chaves
author = {{Fulano de Tal, Jr.}}                        % nome com vírgula: chaves
```

Toda pesquisa pedida ao aluno deve ter fonte citável no `.bib` — inclusive
*datasheets* e normas.

## 10. Estilo de linguagem

- **Terceira pessoa impessoal** no texto teórico ("mede-se", "obtém-se");
  **imperativo** nos roteiros ("meça", "obtenha"). Nunca primeira pessoa.
- **Português com acentuação completa**, inclusive dentro de listagens.
- **Termos estrangeiros e nomes de software** em `\sw{...}`: `\sw{software}`,
  `\sw{datasheet}`, `\sw{Simulink}`, `\sw{MATLAB}`.
- **Códigos de CI** em `\ci{...}`: `\ci{SN7400}` — impede a quebra da sigla no
  fim da linha.
- **Trecho de código no meio da frase** em `\cd{...}`: `\cd{step(sys)}`.
- **Unidades**: espaço fino não-quebrável entre número e unidade —
  `$5\,\text{V}$`, `$1\,\text{kHz}$`. Decimal com vírgula: `$2{,}5$`.
- **Travessão** `---` para aposto, `--` para intervalos (`1--10`), `-` só em
  palavras compostas.
- **Aspas**: use as duplas do LaTeX (crase-crase para abrir, apóstrofo-apóstrofo para fechar), nunca `"`.
- Frases curtas. O leitor está de pé, na bancada.

## 11. Armadilhas conhecidas

1. **`\cd` não funciona dentro do argumento de outra macro** — nem em
   `\objetivos`, `\campo`, `\obs`, `\caption`, `\section`. É `\lstinline`
   (verbatim) por baixo. Nesses lugares escreva
   `\texttt{\textbackslash comando}`.
2. **`\cd{...}` com `%` ou chaves desbalanceadas** quebra: troque o delimitador
   — `\cd|a % b|`.
3. **`\figuraguia` não aceita `\label`** — monte o `figure` à mão (§7).
4. **Não numere aulas, figuras, tabelas ou seções à mão.** Tudo é zerado e
   prefixado por aula automaticamente.
5. **Uma bibliografia só.** Não crie `.bib` por aula; some tudo em
   `referencias.bib`.
6. **Não edite `guiapratico.cls` para resolver um problema de uma aula.** O
   `.cls` é o design do guia inteiro; ajuste local pertence ao `.tex` da aula, e
   se não houver como, o comando novo é que deve ir para o `.cls`.
7. **Referências saindo como `[?]`**: `latexmk -C` e recompile — é o `biber`
   com auxiliares velhos, não erro seu.

## 12. Antes de fechar a aula

- [ ] `make` compila sem erro e sem `Overfull \hbox` gritante;
- [ ] toda figura, tabela e código é citado no texto **antes** de aparecer;
- [ ] nenhum `\ref` saiu como `??` (procure no PDF);
- [ ] as tabelas de preenchimento têm linhas suficientes para as medidas pedidas
      no roteiro, e o roteiro manda registrar em todas elas;
- [ ] a `\listamaterial` cobre tudo o que o roteiro usa — e nada além;
- [ ] os arquivos em `src/` rodam de verdade;
- [ ] os `\input` no `main.tex` estão na ordem em que as aulas acontecem.
