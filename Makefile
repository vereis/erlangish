BASEDIR = $(shell pwd)
BINDIR  = $(BASEDIR)/bin
CONFIGDIR = $(BASEDIR)/config

SYSCONFIG = $(CONFIGDIR)/sys.config
ELVIS = $(BINDIR)/elvis rock

REBAR = rebar3
SHELL = /bin/bash

.PHONY: release test clean

release: app

test: dialyzer eunit ct

clean:
	$(REBAR) clean
	rm -rf $(BASEDIR)/_build


app:
	$(REBAR) release

shell:
	$(REBAR) shell

dialyzer:
	$(REBAR) dialyzer

elvis:
	$(ELVIS) -c $(SYSCONFIG)

eunit:
	$(REBAR) eunit

ct:
	$(REBAR) ct
