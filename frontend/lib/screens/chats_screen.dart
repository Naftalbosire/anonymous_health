import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/screens/conversation_screen.dart';
import 'package:frontend/widgets/constants.dart';
import 'package:frontend/widgets/theme_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart'; // For making API requests

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  // For jsonDecode

  int _selectedIndex = 3; // Set the selected index for Directory
  List<dynamic> users = []; // To store the list of users
  bool isLoading = true; // For loading state
  String errorMessage = ''; // To store error message if any

  // Function to fetch users from the API
  // Function to fetch users from the API
  Future<void> fetchUsers() async {
    try {
      final token = Provider.of<TokenNotifier>(context, listen: false).token;
      Map<String, dynamic> currentUser = JwtDecoder.decode(token!);

      final response =
          await http.get(Uri.parse('${ApiConstants.baseUrl}/api/auth/users'));

      if (response.statusCode == 200) {
        final allUsers =
            jsonDecode(response.body)['users']; // Parse the JSON response
        // Filter users to only include doctors
        final filteredUsers = currentUser['role'] == 'user'
            ? allUsers.where((user) => user['role'] == 'doctor').toList()
            : allUsers.where((user) => user['role'] == 'user').toList();

        setState(() {
          users = filteredUsers; // Update users with the filtered list
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load users';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  // Call fetchUsers when the screen is initialized
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Handle Bottom Navigation Bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/chats');
        break;
      case 2:
        Navigator.pushNamed(context, '/communities');
        break;
      case 3:
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator()) // Show loading spinner
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage)) // Show error message
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Card(
                            child: ListTile(
                              leading:
                                  const Icon(Icons.person, color: Colors.teal),
                              title: Text(user['email']), // Display user email
                              subtitle: Text(
                                  'Role: ${user['role']}'), // Display user role
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConversationScreen(
                                      userId: user['_id'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
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
            icon: Icon(Icons.contact_phone),
            label: 'Directory',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
