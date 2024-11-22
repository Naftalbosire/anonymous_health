import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  // Initialize Socket.io
  void connectToServer() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('private_message', (data) {
      // Handle incoming private message
      print('Received private message: $data');
    });
  }

  // Send a private message
  void sendMessage(String sender, String recipient, String content) {
    socket.emit('private_message', {
      'sender': sender,
      'recipient': recipient,
      'content': content,
    });
  }

  // Disconnect socket
  void disconnect() {
    socket.disconnect();
  }
}
