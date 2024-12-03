import 'package:frontend/widgets/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
        ApiConstants.baseUrl,
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
