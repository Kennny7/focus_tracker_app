import 'package:flutter/material.dart';

class StatsDashboard extends StatelessWidget {
  final Map<String, dynamic> stats;
  final VoidCallback onViewDetails;

  const StatsDashboard({
    super.key,
    required this.stats,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('📊 Quick Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statColumn('Today', '${stats['todayFocusMinutes']} min', '${stats['todayPunishments']} 🚫'),
                _statColumn('This Week', '${stats['weekFocusMinutes']} min', '${stats['weekPunishments']} 🚫'),
                _statColumn('Total', '${stats['totalFocusMinutes']} min', '${stats['totalPunishments']} 🚫'),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onViewDetails,
              child: const Text('View Detailed Statistics →'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String label, String focus, String punishment) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(focus, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(punishment, style: const TextStyle(fontSize: 12, color: Colors.redAccent)),
      ],
    );
  }
}