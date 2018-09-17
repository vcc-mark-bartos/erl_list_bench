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

bench_lists_keysearch(K, N, List, Runs) ->
    eministat:s("lists:keysearch/3", fun() -> do_lists_keysearch(K, N, List, Runs) end, ?TRIALS).

do_lists_keysearch(_, _, _, 0) ->
    ok;
do_lists_keysearch(K, N, List, Runs) ->
    lists:keysearch(K, N, List),
    do_lists_keysearch(K, N, List, Runs-1).

%% =============================================================================
%% proplists:get_value/2
%% =============================================================================

bench_proplists_get_value(K, List, Runs) ->
    eministat:s("proplists:get_value/2", fun() -> do_proplists_get_value(K, List, Runs) end, ?TRIALS).

do_proplists_get_value(_, _, 0) ->
    ok;
do_proplists_get_value(K, List, Runs) ->
    proplists:get_value(K, List),
    do_proplists_get_value(K, List, Runs-1).

%% =============================================================================
%% lookup_loop
%% =============================================================================

bench_lookup_loop(K, List, Runs) ->
    eministat:s("lookup_loop", fun() -> do_lookup_loop(K, List, Runs) end, ?TRIALS).

do_lookup_loop(_, _, 0) ->
    ok;
do_lookup_loop(K, List, Runs) ->
    lookup_loop(K, List),
    do_lookup_loop(K, List, Runs-1).

lookup_loop(_, []) ->
    not_found;
lookup_loop(K, List) ->
    [H|T] = List,
    if H =:= K ->
        ok;
    true ->
        lookup_loop(K, T)
    end.

%% =============================================================================
%% list comprehensions
%% =============================================================================

bench_list_comprehensions(K, List, Runs) ->
    eministat:s("list comprehensions", fun() -> do_list_comprehensions(K, List, Runs) end, ?TRIALS).

do_list_comprehensions(_, _, 0) ->
    ok;
do_list_comprehensions(K, List, Runs) ->
    [X || X <- List, K =:= X],
    do_list_comprehensions(K, List, Runs-1).

%% =============================================================================

datasets() ->
    List = [{rand:uniform(10000000), rand:uniform(10000000)} || _ <- lists:seq(1, ?SIZE)],
    K = rand:uniform(10000000),
    N = 1,
    Runs = ?ROUNDS,

    [bench_lists_keysearch(K, N, List, Runs),
    bench_proplists_get_value(K, List, Runs),
    bench_lookup_loop(K, List, Runs),
    bench_list_comprehensions(K, List, Runs)].

t() ->
    [H|T] = datasets(),
    eministat:x(95.0, H, T).
