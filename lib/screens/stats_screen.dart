import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/location_service.dart';
import '../services/activity_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationService = LocationService();
    final activityService = ActivityService();
    
    final unlockedActivities = activityService.activities
        .where((activity) => activity.status == 'unlocked')
        .toList()
        .reversed
        .take(5)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Общая статистика
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Всего пройдено',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${(locationService.totalDistance / 1000).toStringAsFixed(2)} км',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ачивки',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${activityService.unlockedCount}/${activityService.totalActivities}',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Последние ачивки
            const Text(
              'Последние ачивки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: unlockedActivities.isEmpty
                  ? const Center(
                      child: Text(
                        'Ачивок пока нет',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: unlockedActivities.length,
                      itemBuilder: (context, index) {
                        final activity = unlockedActivities[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: Colors.green[50],
                          child: ListTile(
                            leading: const Icon(
                              Icons.emoji_events,
                              color: Colors.green,
                            ),
                            title: Text(activity.titleRu),
                            subtitle: activity.unlockedAt != null
                                ? Text(
                                    DateFormat('dd.MM.yyyy HH:mm').format(
                                      activity.unlockedAt!,
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
