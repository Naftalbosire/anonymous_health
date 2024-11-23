import 'package:flutter/material.dart';
import 'package:frontend/services/chat_service.dart';
import 'package:frontend/widgets/theme_notifier.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
//import 'chat_service.dart'; // Import your ChatService

class ConversationScreen extends StatefulWidget {
  final String userId;

  const ConversationScreen({
    super.key,
    required this.userId,
  });

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hello!', 'sender': 'me', 'time': '10:00 AM'},
    {'text': 'Hi there!', 'sender': 'User 1', 'time': '10:01 AM'},
    {'text': 'How are you?', 'sender': 'me', 'time': '10:02 AM'},
  ];

  final TextEditingController _controller = TextEditingController();
  late ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _chatService.connectToServer();
    _listenForMessages();
  }

  @override
  void dispose() {
    super.dispose();
    _chatService.disconnect();
  }

  void _sendMessage() async {
    final token = Provider.of<TokenNotifier>(context, listen: false).token;
    Map<String, dynamic> user = JwtDecoder.decode(token!);
    print(user);
    if (_controller.text.isNotEmpty) {
      final content = _controller.text;
      try {
        await _chatService.sendMessage(user["id"], widget.userId, content);
        setState(() {
          messages.add({
            'text': content,
            'sender': widget.userId,
            'time': _getCurrentTime(),
          });
          _controller.clear();
        });
      } catch (e) {
        // Handle error (e.g., show a snackbar)
        print('Error: $e');
      }
    }
  }

  void _listenForMessages() {
    _chatService.socket.on('private_message', (data) {
      setState(() {
        messages.add({
          'text': data['content'],
          'sender': data['sender'],
          'time': _getCurrentTime(),
        });
      });
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userId),
          ],
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'] == widget.userId;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.lightGreenAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(message['text'],
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(
                          message['time'],
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
