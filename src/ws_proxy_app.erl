%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(ws_proxy_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/_irc", ws_handler, []},
            {"/",      cowboy_static, {file, "priv/index.html"}},
            {"/[...]", cowboy_static, {dir,  "priv"}}
        ]}
    ]),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8000}], [
        {env, [{dispatch, Dispatch}]}
    ]),
    ws_proxy_sup:start_link().

stop(_State) ->
    ok.
