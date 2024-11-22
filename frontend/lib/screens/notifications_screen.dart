import 'package:flutter/material.dart';
import 'package:frontend/screens/sound_vibration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:health_app/screens/sound_vibration_screen.dart'; // Import the Sound & Vibration screen

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                _saveNotificationPreference(value); // Save preference
              });
            },
          ),
          ListTile(
            title: const Text('Notification Preferences'),
            onTap: () {
              // Navigate to notification preferences screen
            },
          ),
          ListTile(
            title: const Text('Sound & Vibration'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SoundVibrationScreen(),
                ),
              );
            },
          ),
          // Add more notification settings here as needed
        ],
      ),
    );
  }
}
