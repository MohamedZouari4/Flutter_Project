// File: lib/models/course.dart
// Data model for course information displayed across the app.

import 'package:hive/hive.dart';

/// Represents a course with title, instructor and metadata.
@HiveType(typeId: 0)
class Course {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String instructor;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final int credits;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.imageUrl,
    required this.credits,
  });

  /// Convert to map for DB storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructor': instructor,
      'imageUrl': imageUrl,
      'credits': credits,
    };
  }

  /// Creates a [Course] from a map returned by the DB.
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      instructor: map['instructor'],
      imageUrl: map['imageUrl'],
      credits: map['credits'],
    );
  }
}

/// Manual TypeAdapter for [Course]. Using a manual adapter avoids needing
/// build_runner/codegen so it's simpler to add to small projects.
class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 0;

  @override
  Course read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Course(
      id: fields[0] as int?,
      title: fields[1] as String,
      description: fields[2] as String,
      instructor: fields[3] as String,
      imageUrl: fields[4] as String,
      credits: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.instructor)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.credits);
  }
}
