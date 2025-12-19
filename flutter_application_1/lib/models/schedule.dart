// File: lib/models/schedule.dart
// Model representing a scheduled class or lab session.

import 'package:hive/hive.dart';

/// Represents one scheduled class entry.
@HiveType(typeId: 1)
class Schedule {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String courseName;

  @HiveField(2)
  final String day; // Monday, Tuesday, etc.

  @HiveField(3)
  final String startTime;

  @HiveField(4)
  final String endTime;

  @HiveField(5)
  final String room;

  @HiveField(6)
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

  /// Convert to map for DB insertion.
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

  /// Create model from DB map.
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

/// Manual TypeAdapter for [Schedule].
class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 1;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Schedule(
      id: fields[0] as int?,
      courseName: fields[1] as String,
      day: fields[2] as String,
      startTime: fields[3] as String,
      endTime: fields[4] as String,
      room: fields[5] as String,
      color: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseName)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.room)
      ..writeByte(6)
      ..write(obj.color);
  }
}
