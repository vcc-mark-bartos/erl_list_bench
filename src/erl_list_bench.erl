-module(erl_list_bench).

%% API exports
-export([main/1]).

%%==============================================================================
%% API functions
%%==============================================================================

%% escript Entry point
main(_Args) ->
    io:format("Starting benchmark...~n"),
    t().

%%==============================================================================
%% Internal functions
%%==============================================================================

-define(ROUNDS, 1000).
-define(SIZE, 1000).
-define(TRIALS, 50).

%% =============================================================================
%% lists:keysearch/3
%% =============================================================================

bench_lists_keysearch(Find, List, Runs) ->
    eministat:s("lists:keysearch/3", fun() -> do_lists_keysearch(Find, List, Runs) end, ?TRIALS).

do_lists_keysearch(_, _, 0) ->
    ok;
do_lists_keysearch(Find, List, Runs) ->
    lists:keysearch(Find, 1, List),
    do_lists_keysearch(Find, List, Runs-1).

%% =============================================================================
%% proplists:get_value/2
%% =============================================================================

bench_proplists_get_value(Find, List, Runs) ->
    eministat:s("proplists:get_value/2", fun() -> do_proplists_get_value(Find, List, Runs) end, ?TRIALS).

do_proplists_get_value(_, _, 0) ->
    ok;
do_proplists_get_value(Find, List, Runs) ->
    proplists:get_value(Find, List),
    do_proplists_get_value(Find, List, Runs-1).

%% =============================================================================
%% lookup_loop
%% =============================================================================

bench_lookup_loop(Find, List, Runs) ->
    eministat:s("lookup_loop", fun() -> do_lookup_loop(Find, List, Runs) end, ?TRIALS).

do_lookup_loop(_, _, 0) ->
    ok;
do_lookup_loop(Find, List, Runs) ->
    lookup_loop(Find, List),
    do_lookup_loop(Find, List, Runs-1).

lookup_loop(_, []) ->
    not_found;
lookup_loop(Find, [{H, _}|T]) ->
    if H =:= Find ->
        ok;
    true ->
        lookup_loop(Find, T)
    end.

%% =============================================================================
%% list comprehensions
%% =============================================================================

bench_list_comprehensions(Find, List, Runs) ->
    eministat:s("list comprehensions", fun() -> do_list_comprehensions(Find, List, Runs) end, ?TRIALS).

do_list_comprehensions(_, _, 0) ->
    ok;
do_list_comprehensions(Find, List, Runs) ->
    [X || {X, _} <- List, Find =:= X],
    do_list_comprehensions(Find, List, Runs-1).

%% =============================================================================

datasets() ->
    List = [{rand:uniform(10000000), rand:uniform(10000000)} || _ <- lists:seq(1, ?SIZE)],
    Find = rand:uniform(10000000),
    Runs = ?ROUNDS,

    [bench_lists_keysearch(Find, List, Runs),
    bench_proplists_get_value(Find, List, Runs),
    bench_lookup_loop(Find, List, Runs),
    bench_list_comprehensions(Find, List, Runs)].

t() ->
    [H|T] = datasets(),
    eministat:x(95.0, H, T).
