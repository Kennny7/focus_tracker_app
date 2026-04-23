import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/stats_service.dart';
import '../models/focus_session.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late StatsService _statsService;
  List<FocusSession> _sessions = [];
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _statsService = StatsService(prefs);
    _sessions = await _statsService.getSessions();
    _stats = await _statsService.getStats();
    if (mounted) setState(() {});
  }

  Future<void> _exportCSV() async {
    if (_sessions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No sessions to export')),
      );
      return;
    }

    String? directory = await FilePicker.getDirectoryPath();
    if (directory == null) return;

    List<List<dynamic>> rows = [
      ['Timestamp', 'Duration (seconds)', 'Was Punished', 'Punishment Type']
    ];
    for (var s in _sessions) {
      rows.add([
        s.timestamp.toLocal().toString(),
        s.durationSeconds,
        s.wasPunished,
        s.punishmentType ?? '',
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final file = File('$directory/focus_logs_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics & Achievements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportCSV,
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: _sessions.isEmpty
          ? const Center(child: Text('No focus sessions yet. Start the timer!'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _summaryRow('Total Sessions', _stats['totalSessions']),
                        _summaryRow('Total Focus Time', '${_stats['totalFocusMinutes']} min'),
                        _summaryRow('Total Punishments', _stats['totalPunishments']),
                        _summaryRow('Today Focus', '${_stats['todayFocusMinutes']} min'),
                        _summaryRow('Today Punishments', _stats['todayPunishments']),
                        _summaryRow('This Week Focus', '${_stats['weekFocusMinutes']} min'),
                        _summaryRow('This Week Punishments', _stats['weekPunishments']),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Session History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._sessions.reversed.map((s) => ListTile(
                      leading: Icon(s.wasPunished ? Icons.warning : Icons.check_circle,
                          color: s.wasPunished ? Colors.red : Colors.green),
                      title: Text('${s.durationSeconds ~/ 60} min ${s.durationSeconds % 60} sec'),
                      subtitle: Text(s.timestamp.toLocal().toString()),
                      trailing: s.wasPunished ? const Text('Punished') : null,
                    )),
              ],
            ),
    );
  }

  Widget _summaryRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}