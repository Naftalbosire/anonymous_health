import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: Colors.tealAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              // Show privacy policy
            },
          ),
          ListTile(
            title: const Text('Security Settings'),
            onTap: () {
              // Navigate to security settings screen
            },
          ),
          ListTile(
            title: const Text('Data Management'),
            onTap: () {
              // Navigate to data management settings screen
            },
          ),
          // Add more privacy & security settings here as needed
        ],
      ),
    );
  }
}
