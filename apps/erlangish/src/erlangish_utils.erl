-module(erlangish_utils).

-vsn({0, 0, 1}).

-export([
    wildcard/1,
    init_io_server/0
]).

-spec wildcard(file:filename_all()) -> list(file:filename_all()).
wildcard(F) ->
    case filelib:wildcard(F) of
        [] -> [F];
        Fs -> Fs
    end.

-spec init_io_server() -> ok.
-ifdef(no_print).
init_io_server() ->
    case whereis(actual_standard_error) of
        undefined ->
            StdErr = whereis(standard_error),
            true = unregister(standard_error),
            true = register(actual_standard_error, StdErr);
        _ ->
            true
    end,
    case whereis(standard_error) of
        undefined ->
            true = register(standard_error, erlangish_mock_io:start_link());
        _ ->
            true
    end,
    ok.
-else.
init_io_server() ->
    ok.
-endif.
