import 'package:flutter/material.dart';
import 'main.dart'; // Import where themeNotifier is defined

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Preferences",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            child: SwitchListTile(
              title: const Text("Enable Notifications"),
              secondary: const Icon(Icons.notifications),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
              },
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode),
              value: isDarkMode,
              onChanged: (val) {
                setState(() {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
