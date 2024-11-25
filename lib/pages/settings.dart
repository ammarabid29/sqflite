import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_app/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Consumer<ThemeProvider>(
        builder: (ctx, provider, __) {
          return SwitchListTile.adaptive(
            title: const Text("Dark Mode"),
            subtitle: const Text("Change theme mode"),
            value: provider.getThemeValue(),
            onChanged: (value) {
              provider.updateTheme(value: value);
            },
          );
        },
      ),
    );
  }
}
