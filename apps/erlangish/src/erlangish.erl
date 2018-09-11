-module(erlangish).

-export([
    main/1,

    compile/1,
    compile/2,

    help/0,
    version/0
]).

-define(OPTS, [
    {help,      $h,  "help",      undefined,         "Show help and usage message"},
    {version,   $v,  "version",   undefined,         "Show application version"},
    {processes, $p,  "processes", {integer, -1},     "Number of concurrent processes to use"},
    {export,    $e,  "export",    {string, "js"},    "Compiler output format"},
    {outdir,    $o,  "outdir",    {string, "./"},    "Output directory"}
]).

-define(VSN, "0.0.1").
-define(TERNARY(C, T, F), case C of true -> T; false -> F end).

%% EScript entrypoint
%% Entire thing wrapped in a try ... catch so that we can early return
%% whenever we run help/0 or version/0
-spec main(list(string())) -> {ok,  any()}
                            | {ok,  early_return, atom()}
                            | {err, any()}.
main(Args) ->
    try
        case getopt:parse(?OPTS, Args) of
            {ok, {ParsedArgs, ArgTokens}} ->
                ok = ?TERNARY(lists:member(help,     ParsedArgs), help(),    ok),
                ok = ?TERNARY(lists:member(version,  ParsedArgs), version(), ok),
                ok = ?TERNARY(length(ArgTokens) > 0, ok, help()),

                {_, Workers} = lists:keyfind(processes, 1, ParsedArgs),
                {_, _Outdir} = lists:keyfind(outdir,    1, ParsedArgs),

                Files = lists:umerge([erlangish_utils:wildcard(Token) || Token <- ArgTokens]),

                compile(Files, Workers);
            _ ->
                help()
        end
    of
        Result ->
            {ok, Result}
    catch
        {early_return, Fn} ->
            {ok, early_return, Fn};
        T:E ->
            io:format("Error: ~p:~p~n", [T, E]),
            {err, {T, E}}
    end.

-spec compile(list(file:filename_all())) -> ok.
compile(Files) ->
    compile(Files, -1).

-spec compile(list(file:filename_all()), integer()) -> ok.
compile([], _WorkerCount) when is_integer(_WorkerCount) ->
    help();

compile(Files, WorkerCount) when is_integer(WorkerCount), WorkerCount =< 0 ->
    compile(Files, length(Files));

compile(Files, WorkerCount) when is_integer(WorkerCount) ->
    Jobs    = lists:zip(Files, lists:seq(0, length(Files) - 1)),
    Workers = lists:foldl(fun({F, I}, Acc) ->
                  maps:update_with(I rem WorkerCount, fun(Fs) -> [F | Fs] end, [F], Acc)
              end, #{}, Jobs),

    lists:foreach(fun({Worker, AllocatedJobs}) ->
        io:format("Worker_~p jobs: ~p~n", [Worker, AllocatedJobs])
    end, maps:to_list(Workers)),
    ok.

-spec help() -> no_return().
help() ->
    getopt:usage(?OPTS, ?MODULE_STRING, "[file ...]"),
    throw({early_return, help}).

-spec version() -> no_return().
version() ->
    io:format("~s version: ~s~n", [?MODULE_STRING, ?VSN]),
    throw({early_return, version}).
