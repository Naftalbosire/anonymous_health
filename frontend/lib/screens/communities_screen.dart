import 'package:flutter/material.dart';
import 'package:frontend/widgets/constants.dart';
import 'package:frontend/widgets/theme_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'community_chat.dart'; // Import the CommunityChat screen

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  _CommunitiesScreenState createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  int _selectedIndex = 2; // Set the selected index for Communities
  List<String> communityNames = []; // List to hold community names

  // Fetch groups from the backend
  Future<void> _fetchGroups() async {
    try {
      final token = Provider.of<TokenNotifier>(context, listen: false).token;
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/groups'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        final List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          communityNames =
              data.map((group) => group['name'] as String).toList();
        });
      } else {
        throw Exception('Failed to load groups: ${response.body}');
      }
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  // Add a new group (Make API call)
  Future<void> _createNewGroup(String groupName) async {
    try {
      final token = Provider.of<TokenNotifier>(context, listen: false)
          .token; // Replace with your logic to fetch the stored token
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/groups/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': groupName}),
      );
      if (response.statusCode == 201) {
        _fetchGroups();
      } else {
        throw Exception('Failed to create group: ${response.body}');
      }
    } catch (e) {
      print('Error creating group: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGroups(); // Fetch groups when the screen is initialized
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home'); // Navigate to Home screen
        break;
      case 1:
        Navigator.pushNamed(context, '/chats'); // Navigate to Chats
        break;
      case 2:
        // Stay on Communities
        break;
      case 3:
        Navigator.pushNamed(context, '/directory'); // Navigate to Directory
        break;
    }
  }

  // Show dialog to create a new group
  void _showCreateGroupDialog() {
    TextEditingController groupNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Group'),
          content: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(hintText: 'Enter group name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (groupNameController.text.isNotEmpty) {
                  _createNewGroup(groupNameController
                      .text); // Call the API to create the group
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // You can show a toast or a snackbar if the name is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group name')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: communityNames.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount:
                  communityNames.length, // Use length of the community list
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.group, color: Colors.white),
                    ),
                    title: Text(
                      communityNames[index], // Set community name dynamically
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // subtitle: const Text(
                    //   'Last update or description goes here', // Can show latest updates
                    // ),
                    trailing: const Icon(
                        Icons.arrow_forward_ios), // Arrow to indicate action
                    onTap: () {
                      // Navigate to CommunityChat screen with the community name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityChat(
                            communityName: communityNames[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _showCreateGroupDialog, // Show the dialog to create a new group
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone), // Icon for Telephone Directory
            label: 'Directory', // Label for Telephone Directory
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // Show labels for unselected items
        onTap: _onItemTapped,
        backgroundColor: Colors.black87, // Set background color consistently
      ),
    );
  }
}
