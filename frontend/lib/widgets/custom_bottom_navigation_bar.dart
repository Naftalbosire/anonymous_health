import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed, // Prevents icons from shifting
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home'); // Home route
            break;
          case 1:
            Navigator.pushNamed(context, '/chats'); // Chat route
            break;
          case 2:
            Navigator.pushNamed(context, '/communities'); // Communities route
            break;
          case 3:
            Navigator.pushNamed(context, '/directory'); // Directory route
            break;
        }
      },
    );
  }
}
