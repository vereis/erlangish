-module(erlangish).

-export([
    main/1 
]).

main(Args) ->
    io:format("~p~n", [Args]).
