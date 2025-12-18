class Schedule {
  final int? id;
  final String courseName;
  final String day; // Monday, Tuesday, etc.
  final String startTime;
  final String endTime;
  final String room;
  final String color; // Hex color code

  Schedule({
    this.id,
    required this.courseName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'color': color,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      courseName: map['courseName'],
      day: map['day'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      room: map['room'],
      color: map['color'],
    );
  }
}