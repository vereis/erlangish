-module(erlangish_coregen).

-export([
    compile/1,
    compile/2
]).

-type coregen_output() :: core_erlang
                        | core_erlang_ast.

-type ast() :: any().

%% Compiles an Erlang source code file into a core_erlang AST
-spec compile(file:filename()) -> {ok, ast()}.
compile(ErlangSource) ->
    compile(ErlangSource, core_erlang_ast).

%% Compiles an Erlang source code file into either core_erlang,
%% in memory; or into a core_erlang AST
-spec compile(file:filename(), coregen_output()) -> {ok, binary()}
                                                  | {ok, ast()}.
compile(ErlangSource, core_erlang) ->
    {ok, Module}   = compile:file(ErlangSource, [to_core]),
    CoreErlangFile = atom_to_list(Module) ++ ".core",
    case file:read_file(CoreErlangFile) of
        {ok, Binary} ->
            ok = file:delete(CoreErlangFile),
            {ok, Binary};
        Error ->
            ok = file:delete(CoreErlangFile),
            Error
    end;
compile(ErlangSource, core_erlang_ast) ->
    {ok, Binary} = compile(ErlangSource, core_erlang),
    {ok, Tokens, _} = core_scan:string(binary_to_list(Binary)),
    {ok, _Ast} = core_parse:parse(Tokens). 
