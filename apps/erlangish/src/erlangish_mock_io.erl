-module(erlangish_mock_io).

-vsn({0, 0, 1}).

-export([
    start_link/0,
    init/0,
    loop/1
]).

-define(SERVER, ?MODULE).

-spec start_link() -> pid().
start_link() ->
    spawn_link(?MODULE, init, []).

-spec init() -> no_return().
init() ->
    ?MODULE:loop([]).

-spec loop(list()) -> no_return().
loop(State) ->
    receive
        {io_request, From, ReplyAs, _Request} ->
            From ! {io_reply, ReplyAs, ok},
            ?MODULE:loop(State);
        _Unknown ->
            ?MODULE:loop(State)
    end.
