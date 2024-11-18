import 'package:flutter/material.dart';
import 'package:frontend/screens/auth/registration_screen.dart';
import 'package:frontend/screens/auth/splash_screen.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'widgets/theme_notifier.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
            create: (_) => TokenNotifier()), // Add TokenNotifier
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Anonymous Health',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              brightness:
                  themeNotifier.isDarkMode ? Brightness.dark : Brightness.light,
              drawerTheme: DrawerThemeData(
                backgroundColor: themeNotifier.isDarkMode
                    ? Colors.black
                    : Color.fromARGB(255, 50, 13, 92),
              ),
              textTheme: TextTheme(
                titleLarge: TextStyle(
                  color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
                ),
                bodyMedium: TextStyle(
                  color: themeNotifier.isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              iconTheme: IconThemeData(
                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor:
                    themeNotifier.isDarkMode ? Colors.black : Colors.white,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey,
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              // '/login': (context) => LoginScreen(),
              '/registration': (context) => const RegistrationScreen(),
              '/home': (context) => const HomeScreen(),
              // '/chat': (context) => const ChatsScreen(),
              // '/communities': (context) => CommunitiesScreen(),
              // '/directory': (context) => const DirectoryScreen(),
              // '/profile': (context) => const ProfileScreen(),
              // '/settings': (context) => const SettingsScreen(),
              // '/help': (context) => const HelpScreen(),
              // '/about': (context) => const AboutScreen(),
              // '/notifications': (context) => const NotificationsScreen(),
              // '/privacy_security': (context) => const PrivacySecurityScreen(),
              // '/theme': (context) => const ThemeScreen(),
            },
          );
        },
      ),
    );
  }
}
