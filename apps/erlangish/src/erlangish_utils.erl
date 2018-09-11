-module(erlangish_utils).

-export([
    wildcard/1
]).

-spec wildcard(file:filename_all()) -> list(file:filename_all()).
wildcard(F) ->
    case filelib:wildcard(F) of
        [] -> [F];
        Fs -> Fs
    end.
