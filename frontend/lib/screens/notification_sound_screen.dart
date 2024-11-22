import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSoundScreen extends StatefulWidget {
  const NotificationSoundScreen({super.key});

  @override
  _NotificationSoundScreenState createState() =>
      _NotificationSoundScreenState();
}

class _NotificationSoundScreenState extends State<NotificationSoundScreen> {
  final List<String> _sounds = [
    'notification1.mp3',
    'notification2.mp3',
    'notification3.mp3',
    'notification4.mp3'
  ];
  String _selectedSound = 'notification1.mp3';
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadSoundPreference();
  }

  Future<void> _loadSoundPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSound =
          prefs.getString('notificationSound') ?? 'notification1.mp3';
    });
  }

  Future<void> _saveSoundPreference(String sound) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationSound', sound);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound(String sound) async {
    try {
      print("Playing sound: $sound");
      await _audioPlayer.play(AssetSource('assets/sounds/$sound'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Sound'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView.builder(
        itemCount: _sounds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_sounds[index]),
            trailing: _selectedSound == _sounds[index]
                ? Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              setState(() {
                _selectedSound = _sounds[index];
              });
              _saveSoundPreference(_sounds[index]);
              _playSound(_sounds[index]);
            },
          );
        },
      ),
    );
  }
}
