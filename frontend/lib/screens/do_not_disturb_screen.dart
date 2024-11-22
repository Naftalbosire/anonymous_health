import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoNotDisturbScreen extends StatefulWidget {
  const DoNotDisturbScreen({super.key});

  @override
  _DoNotDisturbScreenState createState() => _DoNotDisturbScreenState();
}

class _DoNotDisturbScreenState extends State<DoNotDisturbScreen> {
  TimeOfDay _startTime = TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 7, minute: 0);
  bool _allowCalls = true;
  bool _allowMessages = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _startTime = TimeOfDay(
        hour: prefs.getInt('startHour') ?? 22,
        minute: prefs.getInt('startMinute') ?? 0,
      );
      _endTime = TimeOfDay(
        hour: prefs.getInt('endHour') ?? 7,
        minute: prefs.getInt('endMinute') ?? 0,
      );
      _allowCalls = prefs.getBool('allowCalls') ?? true;
      _allowMessages = prefs.getBool('allowMessages') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startHour', _startTime.hour);
    await prefs.setInt('startMinute', _startTime.minute);
    await prefs.setInt('endHour', _endTime.hour);
    await prefs.setInt('endMinute', _endTime.minute);
    await prefs.setBool('allowCalls', _allowCalls);
    await prefs.setBool('allowMessages', _allowMessages);
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null && picked != (isStart ? _startTime : _endTime)) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _savePreferences();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Do Not Disturb'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('Start Time'),
            subtitle: Text(_startTime.format(context)),
            onTap: () => _selectTime(context, true),
          ),
          ListTile(
            title: const Text('End Time'),
            subtitle: Text(_endTime.format(context)),
            onTap: () => _selectTime(context, false),
          ),
          SwitchListTile(
            title: const Text('Allow Calls'),
            value: _allowCalls,
            onChanged: (bool value) {
              setState(() {
                _allowCalls = value;
                _savePreferences();
              });
            },
          ),
          SwitchListTile(
            title: const Text('Allow Messages'),
            value: _allowMessages,
            onChanged: (bool value) {
              setState(() {
                _allowMessages = value;
                _savePreferences();
              });
            },
          ),
        ],
      ),
    );
  }
}
