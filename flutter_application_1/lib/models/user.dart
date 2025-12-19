// File: lib/models/user.dart
// Simple model representing a user in the demo app.

import 'package:hive/hive.dart';

/// Represents a user's basic profile data stored locally.
@HiveType(typeId: 2)
class User {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String studentId;

  @HiveField(4)
  final String? password; // Stored in clear-text for demo only; hash in prod.

  @HiveField(5)
  final String? major;

  @HiveField(6)
  final String? year;

  @HiveField(7)
  final String? phone;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.studentId,
    this.password,
    this.major,
    this.year,
    this.phone,
  });

  /// Convert to map for DB / compatibility.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'password': password,
      'major': major,
      'year': year,
      'phone': phone,
    };
  }

  /// Creates a [User] from a DB map.
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      studentId: map['studentId'],
      password: map['password'],
      major: map['major'],
      year: map['year'],
      phone: map['phone'],
    );
  }
}

/// Manual TypeAdapter for [User].
class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return User(
      id: fields[0] as int?,
      name: fields[1] as String,
      email: fields[2] as String,
      studentId: fields[3] as String,
      password: fields[4] as String?,
      major: fields[5] as String?,
      year: fields[6] as String?,
      phone: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.studentId)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.major)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.phone);
  }
}
