import 'package:flutter/material.dart';

class CommunityChat extends StatefulWidget {
  final String communityName;

  const CommunityChat({super.key, required this.communityName});

  @override
  _CommunityChatState createState() => _CommunityChatState();
}

class _CommunityChatState extends State<CommunityChat> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages =
      []; // List to store messages with sender info

  // Function to send a message
  void _sendMessage() {
    String message =
        _controller.text.trim(); // Get the text and trim any extra spaces
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({
          'sender': 'You',
          'message': message
        }); // Add the message to the list
        _controller.clear(); // Clear the text field after sending
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.communityName} Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length, // Display the number of messages
              itemBuilder: (context, index) {
                return Align(
                  alignment: _messages[index]['sender'] == 'You'
                      ? Alignment
                          .centerRight // Align to the right for sent messages
                      : Alignment
                          .centerLeft, // Align to the left for received messages
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _messages[index]['sender'] == 'You'
                          ? Colors
                              .lightBlueAccent // Different color for sent messages
                          : Colors.grey[300], // Color for received messages
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: _messages[index]['sender'] == 'You'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          _messages[index]['sender']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          _messages[index]['message']!, // Display the message
                          style: TextStyle(color: Colors.black),
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
                    controller:
                        _controller, // Bind the controller to the TextField
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,
                      color: const Color.fromARGB(255, 2, 17, 24)),
                  onPressed:
                      _sendMessage, // Call _sendMessage when send button is pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
