import 'package:flutter/material.dart';
import '../models/session.dart';
import '../data/store.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final title = TextEditingController();
  final location = TextEditingController();
  DateTime? date;
  TimeOfDay? start;
  TimeOfDay? end;
  String type = "Class";
  int? editIndex;

  void save() {
    if (title.text.isEmpty || date == null || start == null || end == null) return;

    final s = Session(
      title.text,
      date!,
      start!.format(context),
      end!.format(context),
      location.text,
      type,
    );

    setState(() {
      if (editIndex == null) {
        Store.sessions.add(s);
      } else {
        Store.sessions[editIndex!] = s;
        editIndex = null;
      }
      title.clear();
      location.clear();
      date = null;
      start = null;
      end = null;
      type = "Class";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text("Schedule", style: TextStyle(color: Colors.white, fontSize: 24)),

          TextField(controller: title, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Session Title", labelStyle: TextStyle(color: Colors.white70))),
          TextField(controller: location, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Location (Optional)", labelStyle: TextStyle(color: Colors.white70))),

          Row(children: [
            TextButton(
              onPressed: () async {
                date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100), initialDate: DateTime.now());
                setState(() {});
              },
              child: Text(date == null ? "Pick Date" : DateFormat.yMd().format(date!)),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: type,
              dropdownColor: Colors.black,
              items: ["Class", "Mastery Session", "Study Group", "PSL Meeting"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => type = v!),
            )
          ]),

          Row(children: [
            TextButton(
              onPressed: () async {
                start = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                setState(() {});
              },
              child: Text(start == null ? "Pick Start Time" : start!.format(context)),
            ),
            const Spacer(),
            TextButton(
              onPressed: () async {
                end = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                setState(() {});
              },
              child: Text(end == null ? "Pick End Time" : end!.format(context)),
            ),
          ]),

          ElevatedButton(onPressed: save, child: Text(editIndex == null ? "Add Session" : "Update Session")),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: Store.sessions.length,
              itemBuilder: (_, i) {
                final s = Store.sessions[i];
                return Card(
                  color: Colors.black26,
                  child: ListTile(
                    title: Text(s.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${DateFormat.yMd().format(s.date)} • ${s.start} - ${s.end} • ${s.location} • ${s.type}", style: const TextStyle(color: Colors.white70)),
                    leading: Switch(value: s.present, onChanged: (v) => setState(() => s.present = v)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.amber), onPressed: () {
                        setState(() {
                          title.text = s.title;
                          location.text = s.location;
                          date = s.date;
                          start = TimeOfDay.now();
                          end = TimeOfDay.now();
                          type = s.type;
                          editIndex = i;
                        });
                      }),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => Store.sessions.removeAt(i))),
                    ]),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
