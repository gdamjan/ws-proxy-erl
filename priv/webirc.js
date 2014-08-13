jQuery(function ($) {
   var view = $('#output');
   var input_line = $('#input_line');
   var w = $(window);

   function connect_ws () {
      var loc = window.location, ws_uri, ws_port;
      if (loc.protocol === 'https:') {
          ws_uri = 'wss:';
          ws_port = 8443;
      } else {
          ws_uri = 'ws:';
          ws_port = 8000;
      }
      ws_uri += '//' + loc.hostname + ':' + ws_port + '/_ws';
      return new WebSocket(ws_uri);
   }

   irc = connect_ws();
   irc.onopen = function (event) {
      output('[websocket opened]');
   }
   irc.onclose = function (event) {
      output('[websocket closed]');
   }

   irc.onmessage = function (event) {
      output(event.data);
   }


   function output (m) {
      view.append('<div>' + m + '</div>');
      w.scrollTop(w.scrollTop()+10000);
   }

   $('#input_form').submit(function() {
      var val = input_line.val();
      input_line.val('');
      irc.send(val + '\r\n');
      output(val);
      return false;
   });
})
