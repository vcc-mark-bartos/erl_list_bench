REBAR=rebar3
ERL=erl

all: compile

get-deps:
	@$(REBAR) get-deps

compile:
	@$(REBAR) compile

run: get-deps
	@$(ERL) -noshell -pa ebin -s application start erl_list_bench

shell: get-deps
	@$(REBAR) shell

clean:
	@$(REBAR) clean
