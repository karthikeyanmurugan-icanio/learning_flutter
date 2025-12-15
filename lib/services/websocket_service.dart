import 'dart:async';
import 'dart:io';

class WebSocketService {
  final String url;
  WebSocket? _socket;
  final StreamController<String> _controller = StreamController.broadcast();

  WebSocketService({this.url = 'ws://echo.websocket.org'}) {
    _connect();
  }

  Stream<String> get stream => _controller.stream;

  Future<void> _connect() async {
    try {
      _socket = await WebSocket.connect(url);
      _socket!.listen((data) {
        _controller.add(data.toString());
      }, onDone: () {
        _controller.add('WebSocket closed');
      }, onError: (err) {
        _controller.add('WebSocket error: $err');
      });
    } catch (e) {
      _controller.add('WS connection error: $e');
    }
  }

  void send(String message) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      _socket!.add(message);
    } else {
      // Optionally buffer or report error
      _controller.add('Could not send message: socket not connected');
    }
  }

  void dispose() {
    _socket?.close();
    _controller.close();
  }
}
