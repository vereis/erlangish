-module(erlangish_coregen_SUITE).
-include_lib("common_test/include/ct.hrl").

-export([
    all/0,
    core_erlang_test/1,
    core_erlang_ast_test/1
]).

-define(TESTFILE, "test_module.erl").

all() ->
    [core_erlang_test,
     core_erlang_ast_test].

core_erlang_test(Config) ->
    {data_dir, Datadir} = lists:keyfind(data_dir, 1, Config),
    {ok, Binary} = erlangish_coregen:compile(Datadir ++ ?TESTFILE,
                                              core_erlang),
    true = is_binary(Binary),
    case string:find(Binary, "module '") of
        nomatch -> erlang:error(not_core_erlang);
        _ -> ok
    end.


core_erlang_ast_test(Config) ->
    {data_dir, Datadir} = lists:keyfind(data_dir, 1, Config),
    {ok, Ast} = erlangish_coregen:compile(Datadir ++ ?TESTFILE,
                                          core_erlang_ast),
    c_module = element(1, Ast).

