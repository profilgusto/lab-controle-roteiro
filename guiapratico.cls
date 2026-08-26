%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% guiapratico.cls -- Classe LaTeX para Guias de Aulas Praticas
%%
%% Reproduz o design do "Guia de Aulas Praticas" (UFSJ / Campus Alto Paraopeba)
%% de Edgar Campos Furtado, usado como referencia visual.
%%
%% Opcoes:
%%   dejavu   (padrao) -- usa DejaVu Sans, substituta livre da Verdana (pdflatex)
%%   verdana            -- usa a Verdana real; exige lualatex ou xelatex
%%   citaralf (padrao)  -- citacoes autor-data, ABNT NBR 10520: (SILVA, 2020)
%%   citarnum           -- citacoes numericas, ABNT NBR 10520: [1]
%%   sembib             -- nao carrega o biblatex (guia sem citacoes)
%%   codigocor (padrao) -- listagens de codigo com realce colorido
%%   codigopb           -- listagens em tons de cinza (impressao preto e branco)
%%   10pt|11pt|12pt     -- corpo do texto (padrao: 10pt)
%%   qualquer outra opcao e repassada a classe article
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{guiapratico}[2026/08/18 v1.0 Guia de Aulas Praticas]

\newif\ifguia@verdana \guia@verdanafalse
\DeclareOption{verdana}{\guia@verdanatrue}
\DeclareOption{dejavu}{\guia@verdanafalse}

\newif\ifguia@bib \guia@bibtrue
\def\guia@bibestilo{abnt}
\DeclareOption{citaralf}{\guia@bibtrue\def\guia@bibestilo{abnt}}
\DeclareOption{citarnum}{\guia@bibtrue\def\guia@bibestilo{abnt-numeric}}
\DeclareOption{sembib}{\guia@bibfalse}

\newif\ifguia@codigocor \guia@codigocortrue
\DeclareOption{codigocor}{\guia@codigocortrue}
\DeclareOption{codigopb}{\guia@codigocorfalse}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ExecuteOptions{dejavu,citaralf,codigocor}
\ProcessOptions\relax

\LoadClass[10pt,a4paper,oneside]{article}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pacotes base %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[brazil]{babel}
\RequirePackage[a4paper,left=2cm,right=2cm,top=2cm,bottom=2cm,%
                footskip=1cm,headsep=0pt]{geometry}
\RequirePackage{graphicx}
\RequirePackage{currfile}   % fornece \currfiledir (pasta do .tex em uso)
\RequirePackage{xcolor}
\RequirePackage{array}
\RequirePackage{etoolbox}
\RequirePackage{tabularray}
\RequirePackage{enumitem}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{caption}
\RequirePackage{amsmath,amssymb}
\RequirePackage{siunitx}
\RequirePackage{comment}
% Unidades no padrao brasileiro: virgula decimal, milhar separado por espaco
% fino, faixas escritas com "a" e unidade repetida uma unica vez.
\sisetup{
  output-decimal-marker  = {,},
  group-separator        = {\,},
  group-minimum-digits   = 5,
  range-phrase           = { a },
  range-units            = single,
  per-mode               = symbol,
  separate-uncertainty   = true,
  retain-explicit-plus,                 % "+10,5 V" mantem o sinal escrito
  detect-all                          % unidades herdam a fonte do texto
}
% Ajustes e unidades fora do SI usadas no guia
\DeclareSIUnit{\litre}{L}   % no Brasil o litro e grafado com L maiusculo
\DeclareSIUnit{\bar}{bar}   % removida do SI; redeclarada para evitar aviso
\DeclareSIUnit{\bit}{bit}
\DeclareSIUnit{\bits}{bits}  % plural, para "16 bits"
\DeclareSIUnit{\rpm}{rpm}
\DeclareSIUnit{\voltpp}{V\ensuremath{_{pp}}}
\DeclareSIUnit{\horaaula}{hora/aula}
\RequirePackage{setspace}
\RequirePackage{ragged2e}
\RequirePackage{needspace}
\RequirePackage[hidelinks]{hyperref}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Fontes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifguia@verdana
  \RequirePackage{fontspec}
  \setsansfont{Verdana}[Scale=0.95]
  \setmainfont{Times New Roman}
\else
  \RequirePackage{dejavu}      % DejaVu Sans/Mono (metricamente proxima da Verdana)
  \RequirePackage{tgtermes}    % serifada estilo Times, usada na capa
\fi
\renewcommand{\familydefault}{\sfdefault}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cores %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\definecolor{guiavinho}{HTML}{800000}   % titulos, "Aula", numeros
\definecolor{guiacinza}{HTML}{E6E6E6}   % faixa do titulo e cabecalho de tabelas
\definecolor{guiacinzaescuro}{HTML}{BFBFBF} % caixa dos apendices

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parametros de layout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newlength{\guiaselolargura}   \setlength{\guiaselolargura}{2.6cm}
\newlength{\guiaselogap}       \setlength{\guiaselogap}{0.25cm}
\newlength{\guiafaixaaltura}   \setlength{\guiafaixaaltura}{1.55cm}
\newlength{\guiarotulolargura} \setlength{\guiarotulolargura}{3.7cm}
\newlength{\guiarotulogap}     \setlength{\guiarotulogap}{0.4cm}
\newlength{\guiafaixalargura}
\newlength{\guialogoaltura}    \setlength{\guialogoaltura}{1.0cm}
\newlength{\guialogorecuo}     \setlength{\guialogorecuo}{0.35cm}
% folga reservada de cada lado do titulo da faixa, para ele nunca encostar no
% brasao: o titulo e centralizado na caixa inteira, nao no espaco que sobra.
% O brasao ocupa cerca de \guialogoaltura + \guialogorecuo (~1.35cm) a direita,
% entao 1.9cm ja garante o afastamento e deixa o titulo bem mais largo -- menos
% quebras de linha.
\newlength{\guiatitulofolga}   \setlength{\guiatitulofolga}{1.9cm}
% respiro vertical acima e abaixo do titulo, quando a faixa precisa crescer
\newlength{\guiatitulopadv}    \setlength{\guiatitulopadv}{6pt}
% altura efetiva da faixa em curso: \guiafaixaaltura e apenas o minimo; titulos
% longos aumentam este valor (ver \aula)
\newlength{\guiafaixaalturaatual}

\setlength{\parindent}{1.1cm}
\setlength{\parskip}{0pt}
\linespread{1.12}\selectfont
\emergencystretch=2em
\hyphenpenalty=200
\raggedbottom

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dados do documento %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\guia@def}[2]{\expandafter\newcommand\csname #1\endcsname[1]{%
  \expandafter\gdef\csname guia@#1\endcsname{##1}}%
  \expandafter\gdef\csname guia@#1\endcsname{#2}}

\guia@def{universidade}{UNIVERSIDADE FEDERAL DE SÃO JOÃO DEL-REI}
\guia@def{subtitulos}{PRÓ-REITORIA DE ENSINO DE GRADUAÇÃO -- PROEN\\ CAMPUS ALTO PARAOPEBA}
\guia@def{titulo}{GUIA DE AULAS PRÁTICAS}
\guia@def{unidadecurricular}{}
\guia@def{cursos}{}
\guia@def{professor}{}
\guia@def{arquivo}{}
\guia@def{datadoc}{\today}
\guia@def{revisao}{}
\guia@def{localano}{}

% Brasao institucional: e propriedade da classe, nao do documento -- nao precisa
% ser declarado no main.tex. O caminho e relativo ao diretorio de compilacao.
% Para outro campus/instituicao, troque aqui (ou, pontualmente, com \logo{...}).
\guia@def{logo}{figuras/ufsj-logo.pdf}

% Atalhos publicos para reaproveitar os dados no corpo do texto
\newcommand{\nomeunidade}{\guia@unidadecurricular}
\newcommand{\nomeprofessor}{\guia@professor}
\newcommand{\nomecursos}{\guia@cursos}
\newcommand{\nomearquivo}{\guia@arquivo}

%%%%%%%%%%%%%%%%%%%%%%%%%%% Cabecalho e rodape %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\fancypagestyle{guiamiolo}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0.6pt}%
  \fancyfoot[R]{\normalfont\small Pág.\ \textbf{\thepage}~$|$~\pageref{LastPage}}%
}
\fancypagestyle{guiacapa}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0.6pt}%
  \fancyfoot[C]{\normalfont\guia@localano}%
}
\pagestyle{guiamiolo}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Capa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------------------------------
% Campos da capa
%
% Um campo cujo valor esteja vazio nao e impresso -- nem o rotulo. Se TODOS os
% campos de um grupo estiverem vazios, o grupo inteiro (e o espaco acima dele)
% desaparece. Para omitir um campo, basta nao declara-lo ou declara-lo vazio,
% p.ex. \arquivo{}.
%
% \campocapa{Rotulo:}{\guia@valor}  -- acumula uma linha, se houver valor
% \guia@grupocapa{<espaco antes>}{<fonte>}{<lista de \campocapa>}
% ---------------------------------------------------------------------------
\newcommand{\guia@linhascapa}{}

\newcommand{\campocapa}[2]{%
  \ifdefempty{#2}{}{%
    \appto\guia@linhascapa{%
      \textbf{#1} & \begin{tabular}[t]{@{}l@{}}#2\end{tabular}\\}}}

\newcommand{\guia@grupocapa}[3]{%
  \renewcommand{\guia@linhascapa}{}%
  #3%
  \ifdefempty{\guia@linhascapa}{}{%
    \vspace{#1}%
    {#2\begin{tabular}{r@{\hspace{0.5em}}l}\guia@linhascapa\end{tabular}\par}}}

% ---------------------------------------------------------------------------
% Lista de professores
%
% \professor aceita um nome ou varios, separados por virgula:
%     \professor{Fulano de Tal}
%     \professor{Fulano de Tal, Beltrana de Tal, Sicrano de Tal}
% Com mais de um nome o rotulo vira "Professores:" automaticamente. Os nomes
% saem um por linha; para os separar de outra forma, redefina \guiaprofsep,
% p.ex. \renewcommand{\guiaprofsep}{, } para tudo na mesma linha.
%
% Um nome que contenha virgula (p.ex. "Fulano de Tal, Jr.") precisa vir entre
% chaves: \professor{{Fulano de Tal, Jr.}, Beltrana de Tal}
% ---------------------------------------------------------------------------
\newcommand{\guiaprofsep}{\\}
\newcounter{guia@nprof}
\newcommand{\guia@listaprof}{}
\newcommand{\guia@rotuloprof}{Professor:}

\newcommand{\guia@montaprof}{%
  \setcounter{guia@nprof}{0}%
  \renewcommand{\guia@listaprof}{}%
  \ifdefempty{\guia@professor}{}{%
    \begingroup
    \renewcommand*{\do}[1]{%
      \stepcounter{guia@nprof}%
      \ifnum\value{guia@nprof}=1\relax
        \gappto\guia@listaprof{##1}%
      \else
        \expandafter\gappto\expandafter\guia@listaprof\expandafter{\guiaprofsep##1}%
      \fi}%
    \expandafter\docsvlist\expandafter{\guia@professor}%
    \endgroup}%
  \ifnum\value{guia@nprof}>1\relax
    \renewcommand{\guia@rotuloprof}{Professores:}%
  \else
    \renewcommand{\guia@rotuloprof}{Professor:}%
  \fi}

% ---------------------------------------------------------------------------
% Posicao vertical dos blocos da capa
%
% O titulo, o espaco abaixo dele e os campos (Unidade Curricular / Cursos /
% Professores) formam um UNICO bloco, centralizado verticalmente na altura do
% texto da capa. Os metadados (Arquivo / Data / Revisao) seguem no pe.
%   \guiablogonivel   -- posicao do CENTRO do bloco, como fracao de \textheight
%                        medida a partir do topo (0.5 = centro vertical)
%   \guiatituloespaco -- espaco entre o titulo e os campos
%   \guiarevrecuo     -- distancia entre os metadados e o pe da capa
% ---------------------------------------------------------------------------
% Fontes dos blocos de campos da capa
\newcommand{\guiacapafonte}{\fontsize{14}{19}\selectfont}  % Unidade/Cursos/Professor
\newcommand{\guiacapafontepe}{\normalsize}                 % Arquivo/Data/Revisão

\newcommand{\guiablogonivel}{0.5}
\newlength{\guiatituloespaco} \setlength{\guiatituloespaco}{2.5cm}
\newlength{\guiarevrecuo} \setlength{\guiarevrecuo}{1.2cm}

\newsavebox{\guia@cxcabec}
\newsavebox{\guia@cxtitulo}
\newsavebox{\guia@cxcampos}
\newsavebox{\guia@cxbloco}
\newsavebox{\guia@cxrevisao}
\newlength{\guia@hcabec}
\newlength{\guia@hbloco}
\newsavebox{\guia@cxfaixatit}
\newlength{\guia@hfaixa}

\renewcommand{\maketitle}{%
  \begin{titlepage}
  \thispagestyle{guiacapa}
  \setlength{\parindent}{0pt}

  % --- monta os blocos em caixas, para poder medir a altura de cada um -------
  \sbox{\guia@cxcabec}{%
    \begin{minipage}{\textwidth}
      \begin{minipage}[c]{2.9cm}
        \includegraphics[width=2.6cm]{\guia@logo}
      \end{minipage}%
      \begin{minipage}[c]{\dimexpr\textwidth-2.9cm\relax}
        {\rmfamily\bfseries\large\guia@universidade}\par
        {\fontsize{8}{10.5}\selectfont\guia@subtitulos\par}
      \end{minipage}
    \end{minipage}}
  \sbox{\guia@cxtitulo}{%
    \begin{minipage}{\textwidth}
      \centering{\fontsize{24}{28}\selectfont\bfseries\guia@titulo\par}
    \end{minipage}}
  \sbox{\guia@cxcampos}{%
    \begin{minipage}{\textwidth}
      \centering
      \guia@grupocapa{0pt}{\guiacapafonte}{%
        \campocapa{Unidade Curricular:}{\guia@unidadecurricular}%
        \campocapa{Cursos:}{\guia@cursos}}
      \guia@montaprof
      \guia@grupocapa{0.8cm}{\guiacapafonte}{%
        \campocapa{\guia@rotuloprof}{\guia@listaprof}}
    \end{minipage}}
  \sbox{\guia@cxrevisao}{%
    \begin{minipage}{\textwidth}
      \centering
      \guia@grupocapa{0pt}{\guiacapafontepe}{%
        \campocapa{Arquivo:}{\guia@arquivo}%
        \campocapa{Data:}{\guia@datadoc}%
        \campocapa{Revisão:}{\guia@revisao}}
    \end{minipage}}
  % titulo + espaco + campos formam um unico bloco
  \sbox{\guia@cxbloco}{%
    \begin{minipage}{\textwidth}
      \nointerlineskip\noindent\usebox{\guia@cxtitulo}\par
      \vspace{\guiatituloespaco}%
      \nointerlineskip\noindent\usebox{\guia@cxcampos}\par
    \end{minipage}}
  \setlength{\guia@hcabec}{\dimexpr\ht\guia@cxcabec+\dp\guia@cxcabec\relax}
  \setlength{\guia@hbloco}{\dimexpr\ht\guia@cxbloco+\dp\guia@cxbloco\relax}

  % --- posiciona ------------------------------------------------------------
  % \nointerlineskip: sem isto o TeX insere glue de entrelinha antes de cada
  % bloco e as fracoes de altura saem deslocadas de uma linha por bloco.
  \nointerlineskip\noindent\usebox{\guia@cxcabec}\par
  \vspace{\dimexpr\guiablogonivel\textheight
                  -\guia@hcabec-0.5\guia@hbloco\relax}
  \nointerlineskip\noindent\usebox{\guia@cxbloco}\par
  \vfill
  \nointerlineskip\noindent\usebox{\guia@cxrevisao}\par
  \vspace*{\guiarevrecuo}
  \end{titlepage}
  \setcounter{page}{2}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Faixa de titulo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \guia@faixa[<altura>]{<selo, alinhado ao centro>}{<conteudo da faixa>}
% A altura padrao (\guiafaixaaltura) e so o minimo; quem chama pode passar uma
% altura maior quando o conteudo nao couber (ver \aula).
% Obs.: minipage redefine \textwidth localmente, por isso a largura util da
% faixa e calculada ANTES de abrir qualquer minipage.
\newcommand{\guia@faixa}[3][\guiafaixaaltura]{%
  \setlength{\guiafaixaalturaatual}{#1}%
  \setlength{\guiafaixalargura}{\dimexpr\textwidth-\guiaselolargura-\guiaselogap\relax}%
  \par\noindent
  \begin{minipage}[c][\guiafaixaalturaatual][c]{\guiaselolargura}
    \centering #2
  \end{minipage}\hspace{\guiaselogap}%
  \begin{minipage}[c][\guiafaixaalturaatual][c]{\guiafaixalargura}
    #3
  \end{minipage}\par
  \vspace{2pt}\noindent\rule{\textwidth}{0.8pt}\par
  \vspace{0.6\baselineskip}%
}

\newcounter{aula}
\renewcommand{\theaula}{\arabic{aula}}
\newcommand{\aulanome}{Aula}

% \aula{Titulo da aula}
% \aula[Titulo curto]{Titulo da aula}  -- o titulo curto vai para o sumario;
% use-o quando o titulo longo tiver \\ ou for grande demais para uma linha.
\newcommand{\aula}[2][]{%
  \clearpage
  \refstepcounter{aula}%
  \gdef\guia@prefixo{\theaula}%
  \setcounter{section}{0}%
  \setcounter{figure}{0}\setcounter{table}{0}\setcounter{equation}{0}%
  \setcounter{lstlisting}{0}%
  \phantomsection\addcontentsline{toc}{guiatopo}{Aula \theaula\ -- \ifblank{#1}{#2}{#1}}%
  \setlength{\guiafaixalargura}{\dimexpr\textwidth-\guiaselolargura-\guiaselogap\relax}%
  % Mede o titulo antes de compor a faixa: se ele nao couber na altura padrao,
  % a caixa cinza (e a faixa inteira) crescem junto, em vez de o texto vazar.
  \sbox{\guia@cxfaixatit}{%
    \begin{minipage}[c]{\dimexpr\guiafaixalargura-2\guiatitulofolga\relax}
      \centering\bfseries\fontsize{17}{20}\selectfont #2
    \end{minipage}}%
  \setlength{\guia@hfaixa}{\dimexpr\ht\guia@cxfaixatit+\dp\guia@cxfaixatit
                                    +2\guiatitulopadv+4pt\relax}%
  \ifdim\guia@hfaixa<\guiafaixaaltura
    \setlength{\guia@hfaixa}{\guiafaixaaltura}%
  \fi
  \guia@faixa[\guia@hfaixa]
    {\color{guiavinho}\bfseries
     {\fontsize{13}{14}\selectfont\aulanome\par}%
     \nointerlineskip\vspace{1pt}%
     {\fontsize{30}{30}\selectfont\theaula\par}}
    {\fboxsep=0pt
     \colorbox{guiacinza}{%
       \begin{minipage}[c][\dimexpr\guia@hfaixa-4pt\relax][c]{\guiafaixalargura}
         % o brasao vai numa caixa de largura zero alinhada a direita, para nao
         % deslocar o titulo: assim o titulo fica centralizado na caixa cinza.
         % \vcenter alinha o brasao pelo mesmo eixo da minipage[c] do titulo --
         % sem isto o brasao, mais alto, empurraria o titulo para baixo.
         \noindent\rlap{\makebox[\guiafaixalargura][r]{%
           $\vcenter{\hbox{\includegraphics[height=\guialogoaltura]{\guia@logo}}}$%
           \hspace*{\guialogorecuo}}}%
         \makebox[\guiafaixalargura][c]{\usebox{\guia@cxfaixatit}}%
       \end{minipage}}}%
  \gdef\guia@tituloatual{#2}%
}

% \apendice{Titulo} / \apendice[Titulo curto]{Titulo} -- letras A, B, C...
\newcounter{apendice}
\renewcommand{\theapendice}{\Alph{apendice}}
\newcommand{\apendice}[2][]{%
  \clearpage
  \refstepcounter{apendice}%
  \gdef\guia@prefixo{\theapendice}%
  \setcounter{section}{0}%
  \setcounter{figure}{0}\setcounter{table}{0}\setcounter{equation}{0}%
  \setcounter{lstlisting}{0}%
  \phantomsection\addcontentsline{toc}{guiatopo}{Apêndice \theapendice\ -- \ifblank{#1}{#2}{#1}}%
  \setlength{\guiafaixalargura}{\dimexpr\textwidth-\guiaselolargura-\guiaselogap\relax}%
  \guia@faixa
    {\fboxsep=0pt
     \fcolorbox{black}{guiacinzaescuro}{%
       \begin{minipage}[c][1.1cm][c]{\guiaselolargura}
         \centering\color{guiavinho}\bfseries
         {\fontsize{13}{15}\selectfont Apêndice\par}
         {\fontsize{13}{15}\selectfont\theapendice\par}
       \end{minipage}}}
    {\color{guiavinho}\bfseries\fontsize{14}{18}\selectfont\raggedright #2\par}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Campos rotulados %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \campo{Rotulo:}{conteudo}  -- rotulo em negrito, encostado na margem esquerda;
% a coluna do rotulo tem largura fixa (\guiarotulolargura) para que os valores
% de campos consecutivos fiquem alinhados entre si.
\newcommand{\campo}[2]{%
  \par\nointerlineskip
  \noindent
  \begin{tabular}{@{}>{\RaggedRight\arraybackslash\bfseries}p{\guiarotulolargura}@{\hspace{\guiarotulogap}}%
                    >{\RaggedRight\arraybackslash}p{\dimexpr\textwidth-\guiarotulolargura-\guiarotulogap\relax}@{}}
    #1 & #2
  \end{tabular}\par\medskip
}

% \objetivos{\item ... \item ...}
% Campos com argumento vazio (ou so com espacos) nao sao impressos.
\newcommand{\objetivos}[1]{%
  \ifblank{#1}{}{%
    \campo{Objetivos:}{\begin{itemize}[topsep=0pt,partopsep=0pt,itemsep=1pt,parsep=0pt,leftmargin=1.2em]#1\end{itemize}}}}
\newcommand{\objetivo}[1]{\ifblank{#1}{}{\campo{Objetivo:}{#1}}}
\newcommand{\listamaterial}[1]{\ifblank{#1}{}{\campo{Lista de material:}{#1}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Subsecoes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rotulo indentado em negrito, no estilo "Introdução:"
\newcommand{\subtituloguia}[1]{%
  \par\medskip\needspace{3\baselineskip}%
  \noindent\hspace{\parindent}\textbf{#1}\par\smallskip\nointerlineskip}

\newcommand{\introducao}{\subtituloguia{Introdução:}}

% Titulos de bloco: "PRÁTICA:" a esquerda, "PESQUISA" centralizado
\newcommand{\bloco}[1]{%
  \par\bigskip\needspace{4\baselineskip}%
  \noindent\textbf{\MakeUppercase{#1}}\par\medskip}
\newcommand{\blococentrado}[1]{%
  \par\bigskip\needspace{4\baselineskip}%
  \centerline{\textbf{\MakeUppercase{#1}}}\par\medskip}

\newcommand{\pratica}{\bloco{Prática:}}
\newcommand{\pesquisa}{\blococentrado{Pesquisa}}

% Secao simples, para a Introducao geral do guia
\newcommand{\secaoguia}[1]{%
  \par\bigskip\needspace{4\baselineskip}%
  \noindent\textbf{\MakeUppercase{#1}}\par\medskip}

%%%%%%%%%%%%%%%%%%%%%%% Seccionamento numerado e sumario %%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------------------------------
% Hierarquia do guia (a aula/apendice faz o papel de "capitulo"):
%
%   \aula{...} / \apendice{...}   nivel 0  -- 1, 2, 3... / A, B, C...
%     \section{...}               nivel 1  -- 1.1        / A.1
%       \subsection{...}          nivel 2  -- 1.1.1      / A.1.1
%         \subsubsection{...}     nivel 3  -- 1.1.1.1    / A.1.1.1
%
% Os blocos nao numerados da classe (\introducao, \pratica, \pesquisa,
% \secaoguia, \subtituloguia) continuam existindo e podem ser misturados a
% vontade com os comandos numerados acima -- eles nao entram no sumario.
%
% \guia@prefixo expande para o numero da aula ou a letra do apendice em curso;
% e usado como raiz da numeracao de secoes, figuras, tabelas e listagens.
% ---------------------------------------------------------------------------
\gdef\guia@prefixo{\theaula}

\renewcommand{\thesection}{\guia@prefixo.\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}

\setcounter{secnumdepth}{3}   % numera ate \subsubsection
% Sumario so com o nivel de topo (aulas, apendices, referencias). Para listar
% tambem as secoes, use \setcounter{tocdepth}{1..3} no preambulo do documento.
\setcounter{tocdepth}{0}

% --- Aparencia dos titulos --------------------------------------------------
% \@startsection{nome}{nivel}{recuo}{espaco antes}{espaco depois}{estilo}
% O espaco "antes" positivo mantem o recuo do primeiro paragrafo apos o titulo,
% como acontece com \subtituloguia.
\renewcommand\section{\@startsection{section}{1}{0pt}%
  {\bigskipamount}{0.4\baselineskip}%
  {\needspace{4\baselineskip}\normalfont\bfseries\color{guiavinho}%
   \fontsize{13}{15}\selectfont\raggedright}}
\renewcommand\subsection{\@startsection{subsection}{2}{0pt}%
  {\medskipamount}{0.3\baselineskip}%
  {\needspace{3\baselineskip}\normalfont\bfseries\color{guiavinho}%
   \fontsize{11.5}{14}\selectfont\raggedright}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{0pt}%
  {\medskipamount}{0.2\baselineskip}%
  {\needspace{3\baselineskip}\normalfont\bfseries\raggedright}}

% --- Entradas do sumario ----------------------------------------------------
% Nivel de topo (aulas, apendices, referencias, listas): sem pontilhado, em
% negrito e na cor do guia. O titulo ja vem completo ("Aula 1 -- ...").
\newcommand*{\l@guiatopo}[2]{%
  \ifnum\c@tocdepth>-2\relax
    \addpenalty{-\@highpenalty}%
    \vskip 8pt \@plus\p@
    \setlength\@tempdima{0pt}%
    \begingroup
      \parindent\z@ \rightskip\@pnumwidth
      \parfillskip-\@pnumwidth
      \leavevmode\bfseries\color{guiavinho}%
      \advance\leftskip\@tempdima \hskip-\leftskip
      #1\nobreak\hfil\nobreak\hb@xt@\@pnumwidth{\hss\normalcolor #2}\par
    \endgroup
  \fi}

% Secoes numeradas: recuos generosos, ja que os numeros chegam a "1.1.1.1".
\renewcommand*{\l@section}      {\@dottedtocline{1}{1.2em}{2.8em}}
\renewcommand*{\l@subsection}   {\@dottedtocline{2}{4.0em}{3.6em}}
\renewcommand*{\l@subsubsection}{\@dottedtocline{3}{7.6em}{4.4em}}

% --- Ancoras do hyperref ----------------------------------------------------
% Os contadores section/figure/table/... sao zerados a cada aula, entao o valor
% cru repetiria entre aulas e o hyperref criaria destinos duplicados. As
% ancoras passam a levar o mesmo prefixo da numeracao impressa.
\AtBeginDocument{%
  \def\theHsection{\guia@prefixo.\arabic{section}}%
  \def\theHsubsection{\theHsection.\arabic{subsection}}%
  \def\theHsubsubsection{\theHsubsection.\arabic{subsubsection}}%
  \def\theHfigure{\guia@prefixo.\arabic{figure}}%
  \def\theHtable{\guia@prefixo.\arabic{table}}%
  \def\theHequation{\guia@prefixo.\arabic{equation}}%
  \@ifundefined{c@lstlisting}{}{\def\theHlstlisting{\guia@prefixo.\arabic{lstlisting}}}%
}

% --- \sumario ---------------------------------------------------------------
% Imprime o sumario no estilo dos demais blocos do guia. O proprio sumario nao
% se lista. Use \sumario[Indice] para trocar o titulo.
\newcommand{\sumario}[1][Sumário]{%
  \clearpage
  \secaoguia{#1}%
  \begingroup
    \parskip=0pt\parindent=0pt
    \@starttoc{toc}%
  \endgroup
  \clearpage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roteiros %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Itens numerados no formato "1 -- texto", com numero em negrito
\newlist{roteiro}{enumerate}{2}
\setlist[roteiro,1]{label=\textbf{\arabic*}~--,ref=\arabic*,leftmargin=0pt,
  labelwidth=0pt,labelsep=0.4em,itemindent=!,topsep=6pt,itemsep=8pt,parsep=4pt,align=left}
\setlist[roteiro,2]{label=\textbf{\arabic{roteiroi}.\arabic*}~--,leftmargin=1.2cm,
  topsep=2pt,itemsep=3pt,parsep=2pt}

% listas compactas de apoio
\setlist[itemize]{topsep=3pt,itemsep=1pt,parsep=0pt,leftmargin=1.6em}
\setlist[enumerate]{topsep=3pt,itemsep=2pt,parsep=0pt}

% Normas: "I.1. TITULO -- texto"
\newenvironment{normas}[1][I]%
  {\begin{list}{\normalfont #1.\arabic{enumi}.}%
     {\usecounter{enumi}\setlength{\leftmargin}{1.1cm}\setlength{\labelwidth}{1.0cm}%
      \setlength{\labelsep}{0.1cm}\setlength{\itemsep}{6pt}\setlength{\parsep}{3pt}%
      \setlength{\topsep}{6pt}\setlength{\listparindent}{0pt}}}%
  {\end{list}}
\newcommand{\norma}[1]{\item \textbf{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%% Figuras e tabelas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\thefigure}{\guia@prefixo.\arabic{figure}}
\renewcommand{\thetable}{\guia@prefixo.\arabic{table}}
\captionsetup{font=small,labelfont=bf,labelsep=colon,justification=centering,
              skip=6pt,figurename=Figura,tablename=Tabela}

% \includefigure[largura]{arquivo}
% Inclui uma imagem que mora na pasta img/ AO LADO do .tex que a chama.
% Em aulas/aula-xx/aula.tex, \includefigure{01.png} resolve para
% aulas/aula-xx/img/01.png, independentemente de onde o arquivo for \input.
\newcommand{\includefigure}[2][0.7\textwidth]{%
  \includegraphics[width=#1]{\currfiledir img/#2}}

% \figuraguia[largura]{arquivo}{legenda}
% Figura completa (float + legenda numerada) usando a pasta img/ local.
\newcommand{\figuraguia}[3][0.7\textwidth]{%
  \begin{figure}[H]\centering
    \includefigure[#1]{#2}
    \caption{#3}
  \end{figure}}

% \figuraglobal[largura]{arquivo}{legenda}
% Idem, mas para imagens compartilhadas em figuras/ (caminho a partir da raiz).
\newcommand{\figuraglobal}[3][0.7\textwidth]{%
  \begin{figure}[H]\centering
    \includegraphics[width=#1]{#2}
    \caption{#3}
  \end{figure}}
\RequirePackage{float}

% Tabela no estilo do guia: linhas pretas, cabecalho cinza em negrito
\NewTblrEnviron{tabelaguia}
\SetTblrInner[tabelaguia]{hlines,vlines,rowsep=1.6pt,colsep=5pt,
  row{1}={bg=guiacinza,font=\bfseries},hline{1,Z}={0.9pt},vline{1,Z}={0.9pt}}
\SetTblrOuter[tabelaguia]{}

% Celula vazia com altura util, para o aluno preencher a mao
\newcommand{\vazio}{\rule[-0.7ex]{0pt}{3.0ex}}

% --- Chamadas no texto ------------------------------------------------------
% \rfig{rotulo} -> "Figura N.M"     \req{rotulo} -> "Equação (N.M)"
% O nome vem junto do numero, ligado por espaco inquebravel, e o conjunto todo
% e clicavel (o hyperref ja embrulha o \ref). Assim o texto nunca quebra entre
% "Figura" e o numero, e a chamada acompanha automaticamente a renumeracao.
\newcommand{\rfig}[1]{Figura~\ref{#1}}
\newcommand{\req}[1]{Equação~(\ref{#1})}

%%%%%%%%%%%%%%%%%%%%%%%%% Citacoes e referencias (ABNT) %%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------------------------------
% Citacoes conforme a ABNT NBR 10520:2023 e referencias conforme a
% ABNT NBR 6023:2018, implementadas pelo pacote biblatex-abnt.
%
% O backend e o biber -- o latexmk o executa sozinho, nao ha nada a acrescentar
% no Makefile alem da dependencia do arquivo .bib.
%
% Estilo: \documentclass[citaralf]{guiapratico}  -> (SILVA, 2020)   [padrao]
%         \documentclass[citarnum]{guiapratico}  -> [1]
%         \documentclass[sembib]{guiapratico}    -> sem bibliografia
%
% Uso no documento:
%     \bibliografia{referencias.bib}   % no preambulo, junto dos demais dados
%     ... texto com \cite{chave}, \textcite{chave}, \apud{...} ...
%     \referencias                     % onde a lista deve ser impressa
% ---------------------------------------------------------------------------
\ifguia@bib
  % maxnames=3/minnames=1: ate tres autores saem todos; a partir do quarto,
  % imprime-se o primeiro seguido de "et al.", como preve a NBR 6023:2018.
  % giveninits=false mantem os prenomes por extenso; troque para true se a
  % instituicao exigir prenomes abreviados (SILVA, J. C.).
  % accite=true + sccite=false: a NBR 10520 pede CAIXA ALTA no autor dentro dos
  % parenteses -- (OGATA, 2010) -- e caixa normal fora deles -- Ogata (2010).
  % Para versalete no lugar da caixa alta, use sccite=true (variante tambem
  % aceita por muitas instituicoes).
  \RequirePackage{csquotes}   % recomendado pelo biblatex quando ha babel
  \RequirePackage[backend=biber,style=\guia@bibestilo,
                  giveninits=false,maxnames=3,minnames=1,
                  sccite=false,accite=true]{biblatex}

  % Entradas alinhadas a esquerda e separadas por uma linha em branco, como
  % pede a NBR 6023:2018 (o biblatex-abnt ja faz isto; fixado aqui por clareza).
  \setlength{\bibitemsep}{\baselineskip}

  % Arquivo(s) .bib do documento -- pode ser chamado mais de uma vez.
  \newcommand{\bibliografia}[1]{\addbibresource{#1}}

  % Compatibilidade com o abntex2: \citeonline{k} == \textcite{k}
  %   \cite{k}        -> (SILVA, 2020)        citacao indireta
  %   \textcite{k}    -> Silva (2020)         autor no corpo da frase
  %   \cite[p.~15]{k} -> (SILVA, 2020, p. 15) citacao direta
  %   \apud{a}{b}     -> (A, 1990 apud B, 2020)
  \let\citeonline\textcite

  % Titulo da lista, no mesmo estilo dos demais blocos do guia, com entrada
  % no sumario. Para centralizar, redefina \guia@tituloref.
  \newcommand{\guia@tituloref}[1]{\secaoguia{#1}}
  \defbibheading{guia}[Referências]{%
    \guia@tituloref{#1}%
    \phantomsection\addcontentsline{toc}{guiatopo}{#1}}

  % \referencias            -> "REFERÊNCIAS", em pagina nova
  % \referencias[Titulo]    -> outro titulo (p.ex. "Bibliografia recomendada")
  % Segundo a NBR 14724, as referencias vem depois do texto e ANTES dos
  % apendices.
  \newcommand{\referencias}[1][Referências]{%
    \clearpage
    \printbibliography[heading=guia,title={#1}]}
\else
  % Sem biblatex: \bibliografia e \referencias viram no-ops e qualquer comando de
  % citacao para com uma mensagem clara, em vez de "Undefined control sequence".
  \newcommand{\bibliografia}[1]{}
  \newcommand{\referencias}[1][Referências]{}
  \newcommand{\guia@sembib}[1]{%
    \ClassError{guiapratico}%
      {\string#1\space exige o biblatex}%
      {O documento foi carregado com a opcao [sembib], que desliga a
       bibliografia. Remova-a do \string\documentclass\space para citar.}}
  \@for\guia@cmd:={cite,textcite,citeonline,apud,citeauthor,citeyear,%
                    footcite,parencite,nocite}\do{%
    \expandafter\edef\csname\guia@cmd\endcsname{%
      \noexpand\guia@sembib{\expandafter\noexpand\csname\guia@cmd\endcsname}}}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Blocos de codigo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------------------------------------------------------------------
% Listagens de codigo-fonte (Python, MATLAB/Octave, C/C++, Arduino, VHDL,
% shell, ...), implementadas com o pacote listings -- compila com pdflatex, sem
% -shell-escape.
%
% Uso no documento:
%     \begin{codigo}[language=Python, caption={Filtro digital}, label={cod:filtro}]
%     def filtro(x):
%         return x
%     \end{codigo}
%
%     \begin{codigopython}[caption={...}]  ... \end{codigopython}
%     \begin{codigomatlab}[caption={...}]  ... \end{codigomatlab}
%     \begin{codigoc}, \begin{codigoarduino}, \begin{codigovhdl},
%     \begin{codigobash}, \begin{codigotexto} (sem realce)
%
%     \codigoarquivo[language=Python,caption={...}]{aulas/aula-01/src/pid.py}
%     \cd{printf()}      -- codigo curto no meio do texto
%
% As listagens sao numeradas por aula, como as figuras: "Codigo 1.1:", e entram
% na lista gerada por \listadecodigos.
% ---------------------------------------------------------------------------
\RequirePackage{listings}

\renewcommand{\lstlistingname}{Código}
\renewcommand{\lstlistlistingname}{Lista de códigos}
% O contador lstlisting so e criado pelo listings no \AtBeginDocument dele --
% por isso a numeracao por aula ("Codigo 1.1") e fixada aqui dentro. Tem de ser
% no gancho begindocument/end: um \AtBeginDocument da classe roda ANTES do do
% listings, e a redefinicao seria sobrescrita pelo \gdef\thelstlisting dele.
\AddToHook{begindocument/end}{%
  \@ifundefined{c@lstlisting}{}{%
    \gdef\thelstlisting{\guia@prefixo.\arabic{lstlisting}}}}
% \listadecodigos[Titulo] -- indice das listagens, no estilo dos demais blocos.
\newcommand{\listadecodigos}[1][\lstlistlistingname]{%
  \secaoguia{#1}%
  \phantomsection\addcontentsline{toc}{guiatopo}{#1}%
  \begingroup\parskip=0pt\@starttoc{lol}\endgroup}

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cores das listagens %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefina qualquer uma delas no preambulo para mudar o realce.
\ifguia@codigocor
  \definecolor{codigofundo}{HTML}{F7F7F5}      % fundo da caixa
  \definecolor{codigomoldura}{HTML}{BFBFBF}    % fio da moldura
  \definecolor{codigopalavra}{HTML}{800000}    % palavras reservadas
  \definecolor{codigocomentario}{HTML}{6E7B6E} % comentarios
  \definecolor{codigotexto}{HTML}{2E5D8C}      % cadeias de caracteres
  \definecolor{codigolinha}{HTML}{9A9A9A}      % numeros de linha
\else
  \definecolor{codigofundo}{HTML}{F2F2F2}
  \definecolor{codigomoldura}{HTML}{808080}
  \definecolor{codigopalavra}{HTML}{000000}
  \definecolor{codigocomentario}{HTML}{666666}
  \definecolor{codigotexto}{HTML}{333333}
  \definecolor{codigolinha}{HTML}{999999}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Estilo padrao %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \guiacodigofonte -- fonte do corpo da listagem (monoespacada)
% \guiacodigonum   -- fonte dos numeros de linha
\newcommand{\guiacodigofonte}{\ttfamily\fontsize{8.5}{10.5}\selectfont}
\newcommand{\guiacodigonum}{\ttfamily\fontsize{7}{9}\selectfont\color{codigolinha}}

% literate: com pdflatex o listings nao entende UTF-8 sozinho; a lista abaixo
% garante acentos corretos dentro das listagens (em comentarios e cadeias).
\lstdefinestyle{guiacodigo}{%
  basicstyle=\guiacodigofonte,
  keywordstyle=\bfseries\color{codigopalavra},
  commentstyle=\itshape\color{codigocomentario},
  stringstyle=\color{codigotexto},
  numberstyle=\guiacodigonum,
  numbers=left,
  numbersep=10pt,
  stepnumber=1,
  backgroundcolor=\color{codigofundo},
  frame=single,
  framesep=5pt,
  % A moldura precisa englobar a coluna de numeros: o listings posiciona a
  % regua esquerda em (xleftmargin - framexleftmargin) e os numeros terminam
  % em (xleftmargin - numbersep). Com framexleftmargin > numbersep + largura
  % dos numeros, a numeracao fica dentro da caixa, com folga.
  framexleftmargin=28pt,
  framexrightmargin=5pt,
  rulecolor=\color{codigomoldura},
  xleftmargin=28pt,
  xrightmargin=5pt,
  aboveskip=\medskipamount,
  belowskip=\medskipamount,
  captionpos=t,
  showstringspaces=false,
  showspaces=false,
  showtabs=false,
  tabsize=4,
  breaklines=true,
  breakatwhitespace=false,
  breakindent=1.2em,
  % seta discreta na quebra de linha longa
  prebreak=\mbox{\textcolor{codigolinha}{$\hookleftarrow$}},
  columns=fullflexible,
  keepspaces=true,
  upquote=true,
  extendedchars=true,
  inputencoding=utf8,
  literate=%
    {á}{{\'a}}1 {à}{{\`a}}1 {ã}{{\~a}}1 {â}{{\^a}}1 {ä}{{\"a}}1
    {é}{{\'e}}1 {ê}{{\^e}}1 {è}{{\`e}}1 {ë}{{\"e}}1
    {í}{{\'i}}1 {ì}{{\`i}}1 {î}{{\^i}}1 {ï}{{\"i}}1
    {ó}{{\'o}}1 {õ}{{\~o}}1 {ô}{{\^o}}1 {ò}{{\`o}}1 {ö}{{\"o}}1
    {ú}{{\'u}}1 {ù}{{\`u}}1 {û}{{\^u}}1 {ü}{{\"u}}1
    {ç}{{\c c}}1 {ñ}{{\~n}}1
    {Á}{{\'A}}1 {À}{{\`A}}1 {Ã}{{\~A}}1 {Â}{{\^A}}1
    {É}{{\'E}}1 {Ê}{{\^E}}1 {Í}{{\'I}}1
    {Ó}{{\'O}}1 {Õ}{{\~O}}1 {Ô}{{\^O}}1
    {Ú}{{\'U}}1 {Ü}{{\"U}}1 {Ç}{{\c C}}1
    {º}{{\textordmasculine}}1 {ª}{{\textordfeminine}}1
    {°}{{\textdegree}}1 {µ}{{$\mu$}}1 {Ω}{{$\Omega$}}1
}

% Para listagens sem numeracao de linhas: dispensa o recuo reservado aos
% numeros e usa um respiro simetrico dentro da moldura.
%   \begin{codigotexto}[style=semnumeros]
\lstdefinestyle{semnumeros}{%
  numbers=none,
  framexleftmargin=8pt,
  xleftmargin=8pt,
}

\lstdefinestyle{guiacodigoinline}{%
  style=guiacodigo,
  basicstyle=\ttfamily\small,
  keywordstyle=\ttfamily\small,
  numbers=none,
  frame=none,
  backgroundcolor=,
  breaklines=false,
  xleftmargin=0pt,
  framexleftmargin=0pt,
  aboveskip=0pt,
  belowskip=0pt,
}

\lstset{style=guiacodigo}

% Legenda das listagens no mesmo tamanho das de figura/tabela
\captionsetup[lstlisting]{font=small,labelfont=bf,labelsep=colon,
                          justification=raggedright,singlelinecheck=false,skip=4pt}

%%%%%%%%%%%%%%%%%%%%%%%% Linguagens acrescentadas %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% O listings ja traz Python, Matlab, Octave, C, C++, VHDL, Java, R, sh/bash.
% Abaixo, o dialeto Arduino (C++ com as palavras da API) e um apelido para o
% MATLAB com as funcoes de Control System Toolbox mais usadas no laboratorio.
\lstdefinelanguage{Arduino}[ANSI]{C++}{%
  morekeywords={setup,loop,pinMode,digitalWrite,digitalRead,analogWrite,%
    analogRead,delay,delayMicroseconds,millis,micros,Serial,begin,print,%
    println,available,read,write,attachInterrupt,detachInterrupt,map,%
    constrain,HIGH,LOW,INPUT,OUTPUT,INPUT_PULLUP,LED_BUILTIN,boolean,byte,%
    word,String},%
  sensitive=true,%
}

\lstdefinelanguage{MatlabGuia}[]{Matlab}{%
  morekeywords={tf,ss,zpk,step,impulse,bode,nyquist,rlocus,margin,lsim,%
    feedback,series,parallel,pid,pidtune,c2d,d2c,damp,pole,zero,dcgain,%
    stepinfo,sisotool,linspace,logspace},%
}

\lstalias{arduino}{Arduino}
\lstalias{matlabguia}{MatlabGuia}

%%%%%%%%%%%%%%%%%%%%%%%%% Ambientes e comandos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ambiente generico: a linguagem e as demais chaves do listings vao no
% argumento opcional.
\lstnewenvironment{codigo}[1][]{\lstset{style=guiacodigo,#1}}{}

% Atalhos por linguagem -- so poupam o "language="; aceitam as mesmas chaves.
\lstnewenvironment{codigopython}[1][]{\lstset{style=guiacodigo,language=Python,#1}}{}
\lstnewenvironment{codigomatlab}[1][]{\lstset{style=guiacodigo,language=MatlabGuia,#1}}{}
\lstnewenvironment{codigoc}[1][]{\lstset{style=guiacodigo,language=C,#1}}{}
\lstnewenvironment{codigocpp}[1][]{\lstset{style=guiacodigo,language=C++,#1}}{}
\lstnewenvironment{codigoarduino}[1][]{\lstset{style=guiacodigo,language=Arduino,#1}}{}
\lstnewenvironment{codigovhdl}[1][]{\lstset{style=guiacodigo,language=VHDL,#1}}{}
\lstnewenvironment{codigobash}[1][]{\lstset{style=guiacodigo,language=bash,#1}}{}
% Sem realce: saidas de terminal, arquivos de dados, pseudocodigo.
\lstnewenvironment{codigotexto}[1][]{\lstset{style=guiacodigo,language=,#1}}{}

% \codigoarquivo[opcoes]{arquivo} -- inclui um fonte externo, sem copiar e colar.
\newcommand{\codigoarquivo}[2][]{%
  \lstinputlisting[style=guiacodigo,#1]{#2}}

% \cd{...} -- codigo curto no meio do texto. Se o trecho tiver chaves
% desbalanceadas ou %, use delimitadores: \cd|a % b|
\newcommand{\cd}{\lstinline[style=guiacodigoinline]}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Diversos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\obs}[1]{\par\medskip\noindent\textbf{OBS --} #1\par\medskip}
\newcommand{\ci}[1]{\mbox{#1}}          % codigo de circuito integrado
\newcommand{\sw}[1]{\textit{#1}}        % nome de software/termo estrangeiro

\AtBeginDocument{%
  \hypersetup{pdftitle={\guia@titulo},pdfauthor={\guia@professor},
              pdfsubject={\guia@unidadecurricular}}%
}
\endinput
