class Session {
  String title;
  DateTime date;
  String start;
  String end;
  String location;
  String type;
  bool present;

  Session(
    this.title,
    this.date,
    this.start,
    this.end,
    this.location,
    this.type, {
    this.present = false,
  });
}
