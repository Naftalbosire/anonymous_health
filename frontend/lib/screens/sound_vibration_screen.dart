import 'package:flutter/material.dart';
import 'package:frontend/screens/do_not_disturb_screen.dart';
import 'package:frontend/screens/notification_sound_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:health_app/screens/do_not_disturb_screen.dart'; // Import the Do Not Disturb screen
//import 'package:health_app/screens/notification_sound_screen.dart'; // Import the Notification Sound screen

class SoundVibrationScreen extends StatefulWidget {
  const SoundVibrationScreen({super.key});

  @override
  _SoundVibrationScreenState createState() => _SoundVibrationScreenState();
}

class _SoundVibrationScreenState extends State<SoundVibrationScreen> {
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadVibrationPreference();
  }

  Future<void> _loadVibrationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    });
  }

  Future<void> _saveVibrationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sound & Vibration'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('Notification Sound'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const NotificationSoundScreen(), // Navigate to Notification Sound screen
                ),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Enable Vibration'),
            value: _vibrationEnabled,
            onChanged: (bool value) {
              setState(() {
                _vibrationEnabled = value;
                _saveVibrationPreference(value); // Save preference
              });
            },
          ),
          ListTile(
            title: const Text('Do Not Disturb'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const DoNotDisturbScreen(), // Navigate to Do Not Disturb screen
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
