import 'package:web_socket_client/web_socket_client.dart';

/// WebSocket 客户端封装
class WebSocketClientV2 {
  void start() {
    // Create a WebSocket client.
    final socket = WebSocket(Uri.parse('ws://localhost:8080'));

    // Listen to changes in the connection state.
    socket.connection.listen((state) {
      // Handle changes in the connection state.
    });

// Query the current connection state.
    final connectionState = socket.connection.state;

// Listen to messages from the server.
    socket.messages.listen((message) {
      // Handle incoming messages.
    });

// Send a message to the server.
    socket.send('ping');

// Close the connection.
    socket.close();
  }
}
