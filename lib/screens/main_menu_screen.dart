import 'package:flutter/material.dart';
import 'package:amazing_thailand_explorer/screens/map_screen.dart';
import 'package:amazing_thailand_explorer/screens/stats_screen.dart';
import 'package:amazing_thailand_explorer/screens/achievements_screen.dart';
import 'package:amazing_thailand_explorer/screens/settings_screen.dart';
import 'package:amazing_thailand_explorer/screens/about_screen.dart';
import 'package:amazing_thailand_explorer/widgets/menu_button.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amazing Thailand Explorer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Заголовок
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.explore,
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Исследуй Бангкок',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Открывай новые места и собирай ачивки!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Кнопки меню
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  MenuButton(
                    icon: Icons.map,
                    title: 'Карта',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapScreen()),
                      );
                    },
                  ),
                  
                  MenuButton(
                    icon: Icons.bar_chart,
                    title: 'Статистика',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StatsScreen()),
                      );
                    },
                  ),
                  
                  MenuButton(
                    icon: Icons.emoji_events,
                    title: 'Ачивки',
                    color: Colors.amber,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AchievementsScreen()),
                      );
                    },
                  ),
                  
                  MenuButton(
                    icon: Icons.settings,
                    title: 'Настройки',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  
                  MenuButton(
                    icon: Icons.info,
                    title: 'О приложении',
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  
                  MenuButton(
                    icon: Icons.refresh,
                    title: 'Сбросить данные',
                    color: Colors.red,
                    onTap: () {
                      _showResetDialog(context);
                    },
                  ),
                ],
              ),
            ),
            
            // Информация внизу
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Бангкок, Таиланд',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сброс данных'),
        content: const Text('Вы уверены, что хотите сбросить все данные? Это удалит весь трек и прогресс ачивок.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Реализовать сброс данных
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Данные сброшены')),
              );
            },
            child: const Text('Сбросить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
