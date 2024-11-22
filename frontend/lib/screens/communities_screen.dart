import 'package:flutter/material.dart';
import 'package:frontend/screens/community_chat.dart';
//import 'package:health_app/screens/community_chat.dart'; // Import the CommunityChat screen

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  _CommunitiesScreenState createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  int _selectedIndex = 2; // Set the selected index for Communities

  // List of community names
  final List<String> communityNames = [
    'Mental Health Support',
    'Chronic Illness Warriors',
    'Addiction Recovery Group',
    'Parenting and Child Health',
    'Reproductive Health',
    'LGBTQ+ Health and Support',
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: communityNames.length, // Use length of the community list
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
              subtitle: const Text(
                'Last update or description goes here', // Can show latest updates
              ),
              trailing: const Icon(
                  Icons.arrow_forward_ios), // Arrow to indicate action
              onTap: () {
                // Navigate to CommunityChat screen with the community name
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CommunityChat(communityName: communityNames[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to create a new community
        },
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
