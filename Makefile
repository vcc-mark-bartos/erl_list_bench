REBAR=rebar3
ERL=erl

all: compile

get-deps:
	@$(REBAR) get-deps

compile:
	@$(REBAR) compile

escriptize:
	@$(REBAR) escriptize

run: escriptize
	./_build/default/bin/erl_list_bench

shell:
	@$(REBAR) shell

clean:
	@$(REBAR) clean

.PHONY: all get-deps compile escriptize run shell clean
