%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(ws_proxy_app).
-behaviour(application).

%% API.
-export([start/0]).
-export([start/2]).
-export([stop/1]).

%% API.
start() ->
    application:start(crypto),
    application:start(ranch),
    application:start(cowlib),
    application:start(cowboy),
    application:start(ws_proxy).

start(_Type, _Args) ->
    Priv = priv_dir(),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/_ws",  ws_handler, []},
            {"/",      cowboy_static, {file, Priv ++ "/index.html"}},
            {"/[...]", cowboy_static, {dir,  Priv}}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8000}], [
        {env, [{dispatch, Dispatch}]}
    ]),
    ws_proxy_sup:start_link().

stop(_State) ->
    ok.

% hack around stupid Erlang deficiencies
priv_dir() ->
    case code:lib_dir(ws_proxy, priv) of
        {error,bad_name} ->
            Ebin = filename:dirname(code:which(?MODULE)),
            filename:join(filename:dirname(Ebin), "priv");
        Priv ->
            Priv
    end.

