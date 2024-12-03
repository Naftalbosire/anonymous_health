import 'package:flutter/material.dart';
import 'package:frontend/widgets/constants.dart';
import 'package:frontend/widgets/theme_notifier.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommunityChat extends StatefulWidget {
  final String communityName;
  final String groupId;
  final List members;

  const CommunityChat(
      {super.key,
      required this.communityName,
      required this.groupId,
      required this.members});

  @override
  _CommunityChatState createState() => _CommunityChatState();
}

class _CommunityChatState extends State<CommunityChat> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() async {
    String message = _controller.text.trim();

    final token = Provider.of<TokenNotifier>(context, listen: false).token;
    if (message.isNotEmpty) {
      // Send the message to the backend to save in the database
      final url = Uri.parse(
          '${ApiConstants.baseUrl}/api/groups/${widget.groupId}/messages');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add your authorization header
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'content': message,
        }),
      );

      if (response.statusCode == 201) {
        // If the message is saved successfully in the database, update the UI
        // final responseData = json.decode(response.body);
        setState(() {
          _messages.add({'sender': 'You', 'message': message});
          _controller.clear();
        });
      } else {
        // Handle error if the message fails to save in the database
        print('Failed to save message: ${response.body}');
      }
    }
  }

  String extractUsername(String email) {
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      return email.substring(0, atIndex);
    }
    return ''; // Return empty string if no '@' found
  }

  void _fetchMessages() async {
    final token = Provider.of<TokenNotifier>(context, listen: false).token;
    Map<String, dynamic> currentUser = JwtDecoder.decode(token!);
    try {
      print('${ApiConstants.baseUrl}/api/groups/${widget.groupId}/messages');
      final response = await http.get(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/groups/${widget.groupId}/messages'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          _messages.addAll(data
              .map((e) => {
                    'sender': e['sender']['email'] == currentUser['email']
                        ? 'You'
                        : extractUsername(e['sender']['email'])
                            .toString(), // Convert sender to String
                    'message':
                        e['content'].toString() // Convert content to String
                  })
              .toList());
        });
      } else {
        // Handle non-200 response
        print("Failed to load messages: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors (network issues, etc.)
      print("Error fetching messages: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMessages();
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
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: _messages[index]['sender'] == 'You'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _messages[index]['sender'] == 'You'
                          ? Colors.lightBlueAccent
                          : Colors.grey[300],
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
                          _messages[index]['message']!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Consumer<TokenNotifier>(
            builder: (context, tokenNotifier, child) {
              final token = tokenNotifier.token;
              final currentUser = JwtDecoder.decode(token!);

              // Check if the current user is in the list of members
              if (widget.members.contains(currentUser['_id'])) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.black),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(
                          '${ApiConstants.baseUrl}/api/groups/${widget.groupId}/add-member');
                      final response = await http.post(
                        url,
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        body: json.encode({'memberId': currentUser['_id']}),
                      );

                      if (response.statusCode == 200) {
                        setState(() {
                          widget.members.add(currentUser['_id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('You have joined the group!'),
                          backgroundColor: Colors.green,
                        ));
                      } else {
                        print(response.body);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to join the group'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    child: Text('Join Group'),
                    // style: ElevatedButton.styleFrom(
                    //   primary: Colors.lightBlueAccent,
                    //   onPrimary: Colors.white,
                    // ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
