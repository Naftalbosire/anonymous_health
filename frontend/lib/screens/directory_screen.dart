import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:frontend/widgets/constants.dart';
import 'package:http/http.dart' as http; // For making API requests

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  _DirectoryScreenState createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  int _selectedIndex = 3; // Set the selected index for Directory
  List<dynamic> users = []; // To store the list of users
  bool isLoading = true; // For loading state
  String errorMessage = ''; // To store error message if any

  // Function to fetch users from the API
  // Function to fetch users from the API
  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstants.baseUrl}/api/auth/users'));

      if (response.statusCode == 200) {
        final allUsers =
            jsonDecode(response.body)['users']; // Parse the JSON response
        // Filter users to only include doctors
        final filteredUsers =
            allUsers.where((user) => user['role'] == 'doctor').toList();

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
        title: const Text('Telephone Directory'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
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
                                // You can add any action for the user tap here
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
