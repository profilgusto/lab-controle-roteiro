MAIN = main

all: $(MAIN).pdf

# $(wildcard) devolve vazio em vez de erro quando um diretorio nao existe --
# assim reorganizar as pastas nao quebra o make.
FONTES = $(MAIN).tex guiapratico.cls $(wildcard *.bib) \
         $(wildcard secoes/*.tex) $(wildcard sections/*.tex) \
         $(wildcard aulas/*.tex) $(wildcard aulas/*/*.tex) \
         $(wildcard apendices/*.tex) $(wildcard apendices/*/*.tex) \
         $(wildcard aulas/*/src/*) $(wildcard apendices/*/src/*)

$(MAIN).pdf: $(FONTES)
	latexmk -pdf -interaction=nonstopmode $(MAIN).tex

clean:
	latexmk -c

distclean:
	latexmk -C

.PHONY: all clean distclean
