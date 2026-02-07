import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../data/store.dart';
import 'package:intl/intl.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final title = TextEditingController();
  final course = TextEditingController();
  DateTime? due;
  String priority = "Medium";
  int? editIndex;

  void save() {
    if (title.text.isEmpty || due == null) return;

    setState(() {
      if (editIndex == null) {
        Store.assignments.add(Assignment(title.text, due!, course.text, priority));
      } else {
        Store.assignments[editIndex!] = Assignment(title.text, due!, course.text, priority);
        editIndex = null;
      }
      title.clear();
      course.clear();
      due = null;
      priority = "Medium";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Text("Assignments", style: TextStyle(color: Colors.white, fontSize: 24)),

          TextField(controller: title, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Assignment Title", labelStyle: TextStyle(color: Colors.white70))),
          TextField(controller: course, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Course Name", labelStyle: TextStyle(color: Colors.white70))),

          Row(children: [
            TextButton(
              onPressed: () async {
                due = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100), initialDate: DateTime.now());
                setState(() {});
              },
              child: Text(due == null ? "Pick Due Date" : DateFormat.yMd().format(due!)),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: priority,
              dropdownColor: Colors.black,
              items: ["High", "Medium", "Low"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => priority = v!),
            )
          ]),

          ElevatedButton(onPressed: save, child: Text(editIndex == null ? "Add Assignment" : "Update Assignment")),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: Store.assignments.length,
              itemBuilder: (_, i) {
                final a = Store.assignments[i];
                return Card(
                  color: Colors.black26,
                  child: ListTile(
                    title: Text(a.title, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${a.course} • ${DateFormat.yMd().format(a.dueDate)} • ${a.priority}", style: const TextStyle(color: Colors.white70)),
                    leading: Checkbox(value: a.done, onChanged: (v) => setState(() => a.done = v!)),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.amber), onPressed: () {
                        setState(() {
                          title.text = a.title;
                          course.text = a.course;
                          due = a.dueDate;
                          priority = a.priority;
                          editIndex = i;
                        });
                      }),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => Store.assignments.removeAt(i))),
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
