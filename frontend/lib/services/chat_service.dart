import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  // Initialize Socket.io
  void connectToServer() {
    socket = IO.io('https://anonymous-health.onrender.com', <String, dynamic>{
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
  Future<void> sendMessage(
      String sender, String recipient, String content) async {
    try {
      socket.emit('private_message', {
        'sender': sender,
        'recipient': recipient,
        'content': content,
      });
    } catch (e) {
      print('Failed to send message: $e');
      rethrow; // Optionally rethrow to handle errors in the caller
    }
  }

  // Disconnect socket
  void disconnect() {
    socket.disconnect();
  }
}
