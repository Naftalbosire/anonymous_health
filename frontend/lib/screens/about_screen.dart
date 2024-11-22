import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Anonymous Health App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87, // Set text color to dark grey
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'About the App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This app is designed to provide anonymous support for health-related concerns. Whether you are looking for advice, support groups, or tools to manage your health, we are here to help.',
              style: TextStyle(
                color: Colors.black87, // Set text color to dark grey
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Development Team',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Developed by: Naftal Bosire',
              style: TextStyle(
                color: Colors.black87, // Set text color to dark grey
              ),
            ),
            const Text(
              'Contact: support@anonymoushealthapp.com',
              style: TextStyle(
                color: Colors.black87, // Set text color to dark grey
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Acknowledgments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'We would like to thank all the contributors and the community for their support in making this app possible.',
              style: TextStyle(
                color: Colors.black87, // Set text color to dark grey
              ),
            ),
          ],
        ),
      ),
    );
  }
}
