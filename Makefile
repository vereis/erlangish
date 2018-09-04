BASEDIR = $(shell pwd)
BINDIR  = $(BASEDIR)/bin
CONFIGDIR = $(BASEDIR)/config
BUILDDIR  = $(BASEDIR)/_build

SYSCONFIG = $(CONFIGDIR)/sys.config
ELVIS = $(BINDIR)/elvis rock

REBAR = rebar3
SHELL = /bin/bash

.PHONY: release test clean

release: app escript

test: dialyzer eunit ct

clean:
	$(REBAR) clean
	rm -rf $(BUILDDIR)


app:
	$(REBAR) release

escript:
	$(REBAR) escriptize

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
