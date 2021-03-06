-module(ws_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, Req, _Opts) ->
    {{IP, Port}, _} = cowboy_req:peer(Req),
    io:format("[new websocket connection from ~p:~b]~n", [IP, Port]),
    {upgrade, protocol, cowboy_websocket}.

% websocket handshake will not finish until the tcp is connected first
websocket_init(_TransportName, Req, _Opts) ->
    {ok, Sock} = gen_tcp:connect("chat.freenode.net", 6667, [binary, {packet, line}, {active, true}]),
    {ok, Req, Sock}.

% WS -> TCP
websocket_handle({text, Data}, Req, Socket) ->
    gen_tcp:send(Socket, Data),
    {ok, Req, Socket};

websocket_handle(_Frame, Req, Socket) ->
    {ok, Req, Socket}.

% TCP -> WS
websocket_info({tcp, Socket, Data}, Req, Socket) ->
    {reply, {text, Data}, Req, Socket};

websocket_info({tcp_closed, Socket}, Req, Socket) ->
    {reply, close, Req, Socket};

websocket_info(_Info, Req, Socket) ->
    {ok, Req, Socket}.

websocket_terminate(_Reason, Req, Socket) ->
    {{IP, Port}, _} = cowboy_req:peer(Req),
    io:format("[websocket connection from ~p:~b closed]~n", [IP, Port]),
    gen_tcp:close(Socket),
    ok.
