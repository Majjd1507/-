import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Уведомления'),
            trailing: Switch(
              value: true, // dummy value
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Управление аккаунтом'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Политика конфиденциальности'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Выйти'),
            onTap: () {
              // Logout logic
            },
            textColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
