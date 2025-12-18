class Course {
  final int? id;
  final String title;
  final String description;
  final String instructor;
  final String imageUrl;
  final int credits;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.imageUrl,
    required this.credits,
  });

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