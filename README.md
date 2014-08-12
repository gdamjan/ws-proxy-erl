WebSocket to TCP proxy in Erlang with Cowboy
============================================


Curently used as a IRC test app.


Hardcoded:
 * line 15 in `ws_handler.erl` the host and port of `gen_tcp:connect` (and {packet, line})
 * line 6 in `webirc.js` in `function connect_ws` websocket ports (because I'd like to try this on openshift)
 * line 11 in `ws_proxy_app.erl` the http listen port (openshift uses different ports for http and websockets)
 * `/_irc` the websocket endpoint in both `webirc.js` and `ws_proxy_app.erl`



HOW
===

Compile:

    rebar get-deps
    rebar compile


Then run:

    rebar shell
    1> application:start(crypto), application:start(ranch), application:start(cowlib),
    application:start(cowboy), application:start(ws_proxy).

Or:

    ERL_LIBS=$PWD:$PWD/deps erl -s ws_proxy_app


An Erlang release
=================

Erlang has this things called releases, `relx` is a tool to create a release from the source.

    relx

It will create a release in `_rel`. To run it:

    _rel/ws_proxy/bin/ws_proxy start

or

    _rel/ws_proxy/bin/ws_proxy foreground

You can also attach to a running instance with:

    _rel/ws_proxy/bin/ws_proxy remote_console



IRC commands
============

    NICK nickname
    USER nickname 8 * :Firstname Surname
    PONG :...
    JOIN #chanellname
    PRIVMSG #channelname :message
