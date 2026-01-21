import 'package:flutter/material.dart';
import 'main_menu_screen.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.bar_chart, size: 60, color: Colors.green),
                    const SizedBox(height: 10),
                    const Text(
                      'Ваша статистика',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    StatItem(
                      icon: Icons.directions_walk,
                      title: 'Всего пройдено',
                      value: '3.45 км',
                      color: Colors.blue,
                    ),
                    StatItem(
                      icon: Icons.emoji_events,
                      title: 'Открыто ачивок',
                      value: '12/30',
                      color: Colors.green,
                    ),
                    StatItem(
                      icon: Icons.timer,
                      title: 'Время активности',
                      value: '2 ч 15 мин',
                      color: Colors.amber,
                    ),
                    StatItem(
                      icon: Icons.place,
                      title: 'Посещено мест',
                      value: '8',
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Последние активности',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView(
                          children: const [
                            ActivityItem(
                              title: 'Храм Ват Арун',
                              time: '10:30',
                              date: 'Сегодня',
                              icon: Icons.temple_buddhist,
                            ),
                            ActivityItem(
                              title: 'Королевский дворец',
                              time: 'Вчера 14:20',
                              date: 'Вчера',
                              icon: Icons.castle,
                            ),
                            ActivityItem(
                              title: 'Рынок Чатучак',
                              time: 'Вчера 11:45',
                              date: 'Вчера',
                              icon: Icons.shopping_cart,
                            ),
                            ActivityItem(
                              title: 'Парк Лумпхини',
                              time: '2 дня назад',
                              date: '2 дня назад',
                              icon: Icons.park,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final IconData icon;

  const ActivityItem({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(time),
        trailing: Text(
          date,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
