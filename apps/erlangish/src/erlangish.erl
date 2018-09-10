-module(erlangish).

-export([
    main/1
]).

-define(OPTS, [
    {help,      $h,  "help",      undefined,         "Show help and usage message"},
    {version,   $v,  "version",   undefined,         "Show application version"},
    {processes, $p, "processes",  {integer, -1},     "Number of concurrent processes to use"},
    {export,    $e,  "export",    {string, "js"},    "Compiler output format"},
    {output,    $o,  "output",    {string, "./"},    "Output directory"}
]).

-define(VSN, "0.0.1").

-define(TERNARY(C, T, F), case C of true -> T; false -> F end).

%% EScript entrypoint
-spec main(list(any())) -> ok.
main(Args) ->
    case getopt:parse(?OPTS, Args) of
        {ok, {ParsedArgs, ArgTokens}} ->
            ok = ?TERNARY(lists:member(help,    ParsedArgs), help(),    ok),
            ok = ?TERNARY(lists:member(version, ParsedArgs), version(), ok),
            io:format("Args: ~p :: ~p", [ParsedArgs, ArgTokens]);
        _ ->
            help()
    end,
    ok.

%% Internal functions
-spec help() -> ok.
help() ->
    getopt:usage(?OPTS, ?MODULE_STRING, "[file ...]"),
    ok.

-spec version() -> ok.
version() ->
    io:format("~s version: ~s~n", [?MODULE_STRING, ?VSN]),
    ok.
