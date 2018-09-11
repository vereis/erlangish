-module(erlangish_tests).
-include_lib("eunit/include/eunit.hrl").

help_test() ->
    ?assertThrow({early_return, help}, erlangish:help()).

version_test() ->
    ?assertThrow({early_return, version}, erlangish:version()).

main_test_() ->
    [
        test_show_help_if_bad_args(),
        test_help_and_version_priority()
    ].

%% Any args that aren't understood should trigger help message
%% If no flags nor files are supplied, trigger help message
%% If no flags are supplied, but files are, then everything is fine
test_show_help_if_bad_args() ->
    [
        ?_assertEqual({ok, ok}, erlangish:main(["a", "b", "c"])),
        ?_assertEqual({ok, ok}, erlangish:main(["a", "b", "c", "--processes", "6"])),
        ?_assertEqual({ok, early_return, help}, erlangish:main(["a", "b", "c", "-random"])),
        ?_assertEqual({ok, early_return, help}, erlangish:main([]))
    ].

%% Help should have higher priority than all other flags
%% Version should have second highest priority than all other flags
test_help_and_version_priority() ->
    [
        ?_assertEqual({ok, early_return, help},    erlangish:main(["-h"])),
        ?_assertEqual({ok, early_return, version}, erlangish:main(["-v"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["-h", "-v"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["-v", "-h"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "-h"])),
        ?_assertEqual({ok, early_return, version}, erlangish:main(["a", "b", "c", "-v"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "-v", "-h"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "-h", "-v"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "-h", "-v", "-v"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "-h", "-v", "-h"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["--help"])),
        ?_assertEqual({ok, early_return, version}, erlangish:main(["--version"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["--help", "--version"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["--version", "--help"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "--help"])),
        ?_assertEqual({ok, early_return, version}, erlangish:main(["a", "b", "c", "--version"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "--version", "--help"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "--help", "--version"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "--help", "--version", "--version"])),
        ?_assertEqual({ok, early_return, help},    erlangish:main(["a", "b", "c", "--help", "--version", "--help"]))
    ].
