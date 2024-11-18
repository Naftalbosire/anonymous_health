import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedAvatar = 'assets/images/avatar0.png'; // Default avatar path
  String _username = ''; // Placeholder for username
  final List<String> _avatars = [
    'assets/images/avatar0.png',
    'assets/images/avatar1.png',
    'assets/images/avatar2.png',
    'assets/images/avatar3.png',
    'assets/images/avatar4.png',
    'assets/images/avatar5.png',
    'assets/images/avatar6.png',
    'assets/images/avatar7.png',
    'assets/images/avatar8.png',
    'assets/images/avatar9.png',
    'assets/images/avatar10.png',
    'assets/images/avatar11.png',
    'assets/images/avatar12.png',
    'assets/images/avatar13.png',
    'assets/images/avatar14.png',
  ]; // Your avatar list

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load saved data on initialization
  }

  // Load avatar and username from SharedPreferences
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAvatar = prefs.getString('selectedAvatar') ?? _selectedAvatar;
      _username = prefs.getString('username') ?? ''; // Load saved username
    });
  }

  // Save avatar and username to SharedPreferences
  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedAvatar', _selectedAvatar);
    prefs.setString('username', _username); // Save username
  }

  // Call this method whenever the avatar or username changes
  void _updateProfile(String avatar, String username) {
    setState(() {
      _selectedAvatar = avatar;
      _username = username;
    });
    _saveProfileData(); // Save changes
  }

  // Method to show avatar selection dialog
  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an Avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _updateProfile(_avatars[index], _username);
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      _avatars[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(_selectedAvatar),
              radius: 60,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                _username = value; // Update username
              },
              decoration: InputDecoration(labelText: 'Username'),
              controller: TextEditingController(
                  text: _username), // Initialize with saved username
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _showAvatarSelectionDialog, // Open avatar selection dialog
              child: const Text('Select Avatar'),
            ),
          ],
        ),
      ),
    );
  }
}
