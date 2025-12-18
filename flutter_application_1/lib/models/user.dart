class User {
  final int? id;
  final String name;
  final String email;
  final String studentId;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      studentId: map['studentId'],
    );
  }
}