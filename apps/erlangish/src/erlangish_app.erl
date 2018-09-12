-module(erlangish_app).

-vsn({0, 0, 1}).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    erlangish_sup:start_link().

stop(_State) ->
    ok.
