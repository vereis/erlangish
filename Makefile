BASEDIR = $(shell pwd)
REBAR   = rebar3
SHELL   = /bin/bash

release:
	$(REBAR) release

test: dialyzer eunit ct

dialyzer:
	$(REBAR) dialyzer

eunit:
	$(REBAR) eunit

ct:
	$(REBAR) ct
