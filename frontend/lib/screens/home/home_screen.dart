import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home/welcome_screen.dart';
import 'dart:async';

import 'package:frontend/widgets/theme_notifier.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greetingMessage = '';
  Timer? _timer;
  String avatarImage = 'assets/images/homescreen.png'; // Default avatar image
  int _selectedIndex = 0; // To track selected tab

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateGreeting();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour < 12) {
        greetingMessage = 'Good Morning';
      } else if (hour < 17) {
        greetingMessage = 'Good Afternoon';
      } else {
        greetingMessage = 'Good Evening';
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/chat');
        break;
      case 2:
        Navigator.pushNamed(context, '/communities');
        break;
      case 3:
        Navigator.pushNamed(context, '/directory');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text('HealthApp'),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildGradientBackground(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingSection(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildHomeCard(
                          'Unread Messages',
                          Icons.message,
                          Colors.white,
                          'You have  unread messages',
                          Colors.lightBlueAccent,
                        ),
                        const SizedBox(height: 20),
                        _buildHomeCard(
                          'Communities',
                          Icons.group,
                          Colors.white,
                          'Join conversations',
                          Colors.teal,
                        ),
                        const SizedBox(height: 20),
                        _buildHomeCard(
                          'What\'s New',
                          Icons.new_releases,
                          Colors.white,
                          'Discover the latest updates',
                          Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: _buildExploreButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Build the gradient background
  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  // Build the greeting section
  Widget _buildGreetingSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(avatarImage),
          radius: 40,
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greetingMessage,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build the explore button with gradient style
  Widget _buildExploreButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.explore),
      label: const Text('Explore More'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
    );
  }

  // Build the custom drawer for navigation
  Widget _buildDrawer() {
    String? token = Provider.of<TokenNotifier>(context).token;
    Map user = {};

    try {
      final jwt = JWT.decode(token!);
      user = jwt.payload ?? 'null';

      // print(user.toString());
    } catch (e) {
      print('Error decoding token: $e');
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(avatarImage),
                  radius: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  user['email'] ?? 'guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, 'Profile', '/profile'),
          _buildDrawerItem(Icons.settings, 'Settings', '/settings'),
          _buildDrawerItem(Icons.help, 'Help & Support', '/help'),
          // _buildDrawerItem(Icons.logout, 'Logout', '/logout'),
          logout(),
        ],
      ),
    );
  }

  ListTile logout() {
    return ListTile(
      leading:
          const Icon(Icons.logout, color: Colors.white70), // Fixed icon color
      title: const Text('Logout', style: TextStyle(color: Colors.white)),
      onTap: () {
        // Show a confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Clear the token using TokenNotifier
                    Provider.of<TokenNotifier>(context, listen: false)
                        .clearToken();

                    // Navigate to WelcomeScreen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()),
                      (Route<dynamic> route) =>
                          false, // Remove all previous routes
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Build drawer items for better navigation
  Widget _buildDrawerItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70), // Fixed icon color
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  // Build home cards with smooth shadows and opacity
  Widget _buildHomeCard(String title, IconData icon, Color iconColor,
      String subtitle, Color bgColor) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
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
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black87,
    );
  }
}
