import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
        'http://localhost:5000',
        IO.OptionBuilder()
            .setTransports(['websocket']) // Use WebSocket only
            .disableAutoConnect() // Prevent auto connection
            .build());
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
  }
}
