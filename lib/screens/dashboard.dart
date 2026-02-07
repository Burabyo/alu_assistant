import 'package:flutter/material.dart';
import '../data/store.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  int academicWeek() {
    final start = DateTime(DateTime.now().year, 1, 1);
    final diff = DateTime.now().difference(start).inDays;
    return (diff / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayStr = DateFormat.yMMMMd().format(today);

    final todaysSessions = Store.sessions.where((s) =>
        s.date.year == today.year &&
        s.date.month == today.month &&
        s.date.day == today.day).toList();

    final total = Store.sessions.length;
    final present = Store.sessions.where((s) => s.present).length;
    final percent = total == 0 ? 100 : ((present / total) * 100).round();

    final pending = Store.assignments.where((a) => !a.done).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(todayStr, style: const TextStyle(color: Colors.white70)),
            Text("Academic Week ${academicWeek()}", style: const TextStyle(color: Colors.amber)),
            const SizedBox(height: 20),

            _card(
              "Attendance",
              "$percent%",
              percent < 75 ? "⚠️ Below 75% Attendance" : "Good Standing",
              alert: percent < 75,
            ),

            const SizedBox(height: 12),

            _card("Pending Assignments", "$pending", "Assignments not yet completed"),

            const SizedBox(height: 20),

            const Text("Today's Sessions", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),

            if (todaysSessions.isEmpty)
              const Text("No sessions scheduled for today.", style: TextStyle(color: Colors.white70))
            else
              ...todaysSessions.map((s) => ListTile(
                    title: Text(s.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${s.start} - ${s.end} • ${s.location}", style: const TextStyle(color: Colors.white70)),
                  ))
          ],
        ),
      ),
    );
  }

  Widget _card(String title, String value, String subtitle, {bool alert = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alert ? Colors.red.withOpacity(0.2) : Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alert ? Colors.red : Colors.transparent),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.white70)),
      ]),
    );
  }
}
