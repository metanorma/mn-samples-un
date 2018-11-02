SRC  := $(wildcard unece-*.adoc)
XML  := $(patsubst %.adoc,%.xml,$(SRC))
HTML := $(patsubst %.adoc,%.html,$(SRC))
DOC  := $(patsubst %.adoc,%.doc,$(SRC))
PDF  := $(patsubst %.adoc,%.pdf,$(SRC))

SHELL := /bin/bash
COMPILE_CMD_LOCAL := bundle exec metanorma -t unece -x xml,html,doc $$FILENAME
COMPILE_CMD_DOCKER := docker run -v "$$(pwd)":/metanorma/ ribose/metanorma "bundle; metanorma -t unece -x xml,html,doc $$FILENAME"

ifdef METANORMA_DOCKER
  COMPILE_CMD := echo "DOCKER"; $(COMPILE_CMD_DOCKER)
else
  COMPILE_CMD := echo "LOCAL"; $(COMPILE_CMD_LOCAL)
endif

all: $(HTML) $(XML) $(PDF)

clean: clean-pdf clean-xml clean-html clean-doc

clean-pdf:
	rm -f $(PDF)

clean-doc:
	rm -f $(DOC)

clean-xml:
	rm -f $(XML)

clean-html:
	rm -f $(HTML)

bundle:
	bundle

%.xml %.html %.doc %.pdf:	%.adoc #| bundle
	FILENAME=$^; \
	${COMPILE_CMD}

html: clean-html $(HTML)

open:
	open $(HTML)

.PHONY: bundle all open
