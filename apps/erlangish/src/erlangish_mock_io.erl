-module(erlangish_mock_io).

-export([
    start_link/0,
    init/0,
    loop/1
]).

-define(SERVER, ?MODULE).

start_link() ->
    spawn_link(?MODULE, init, []).

init() ->
    ?MODULE:loop([]).

loop(State) ->
    receive
        {io_request, From, ReplyAs, _Request} ->
            From ! {io_reply, ReplyAs, ok},
            ?MODULE:loop(State);
        _Unknown ->
            ?MODULE:loop(State)
    end.
