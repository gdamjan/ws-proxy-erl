WebSocket to TCP proxy in Erlang with Cowboy
============================================


Curently used as a IRC test app.


Hardcoded:
 * line 15 in `ws_handler.erl` the host and port of `gen_tcp:connect`
 * line 6 in `webirc.js` in `function connect_ws` websocket ports (because I'd like to try this on openshift)
 * line 11 in `ws_proxy_app.erl` the http listen port (openshift uses different ports for http and websockets)
 * dir/file in `ws_proxy_app.erl` for cowboy_static depend on teh current dir beeing the project dir, should be moved to
   priv_dir but that requires the use of Erlang releases



HOW
===

    rebar get-deps
    rebar compile
    rebar shell
    1> application:start(crypto), application:start(ranch), application:start(cowlib),
    application:start(cowboy), application:start(ws_proxy).



IRC commands
============

    NICK nickname
    USER nickname 8 * :Firstname Surname
    PONG :...
    JOIN #chanellname
    PRIVMSG #channelname :message
