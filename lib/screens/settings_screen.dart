import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainMenuScreen()),
            );
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: const Text('Уведомления'),
            trailing: Switch(value: true, onChanged: (value) {}),
          ),
          ListTile(
            leading: const Icon(Icons.map, color: Colors.green),
            title: const Text('Тип карты'),
            trailing: const Text('OSM'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.straighten, color: Colors.orange),
            title: const Text('Единицы измерения'),
            trailing: const Text('Километры'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.purple),
            title: const Text('Политика конфиденциальности'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.teal),
            title: const Text('Помощь'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.red),
            title: const Text('Обратная связь'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
