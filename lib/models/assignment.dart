class Assignment {
  String title;
  DateTime dueDate;
  String course;
  String priority;
  bool done;

  Assignment(this.title, this.dueDate, this.course, this.priority, {this.done = false});
}
