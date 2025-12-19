import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/hive_service.dart';

/// Details screen for a single [Course].
class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  bool _isEnrolled = false;
  bool _isSaved = false;
  // Use Hive-backed service for data persistence
  final HiveService _db = HiveService();

  @override
  void initState() {
    super.initState();
    _loadRelated();
    _isEnrolled = widget.course.isEnrolled;
    _isSaved = widget.course.isSaved;
  }

  List<Course> _related = [];

  /// Loads related courses from the database excluding the current one.
  Future<void> _loadRelated() async {
    final all = await _db.getCourses();
    setState(() {
      _related = all
          .where((c) => c.title != widget.course.title)
          .take(5)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {
              // placeholder: share
            },
          ),
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () async {
              final newSaved = !_isSaved;
              setState(() => _isSaved = newSaved);
              await _db.setCourseSaved(widget.course, newSaved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(newSaved ? 'Saved' : 'Removed')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image Header
            Container(
              width: double.infinity,
              height: 220,
              color: Colors.grey[300],
              child: Image.network(
                widget.course.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    Icon(Icons.school, size: 80, color: Colors.grey[400]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Instructor
                  Text(
                    widget.course.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        widget.course.instructor,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Credits & Rating Row
                  Row(
                    children: [
                      _buildInfoChip(
                        '${widget.course.credits} Credits',
                        Icons.school,
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip('4.8 ⭐', Icons.star),
                      SizedBox(width: 12),
                      _buildInfoChip('156 Students', Icons.group),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Syllabus
                  Text(
                    'Syllabus',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children: List.generate(
                      6,
                      (i) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text('${i + 1}'),
                        ),
                        title: Text('Week ${i + 1}: Topic overview'),
                        subtitle: Text(
                          'Short description of topics covered this week.',
                        ),
                      ),
                    ),
                  ),

                  // Description
                  Text(
                    'About This Course',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.course.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),

                  SizedBox(height: 24),

                  // What You'll Learn
                  Text(
                    'What You\'ll Learn',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildLearningPoint(
                    'Understand core concepts and fundamentals',
                  ),
                  _buildLearningPoint(
                    'Build real-world projects and applications',
                  ),
                  _buildLearningPoint('Master industry best practices'),
                  _buildLearningPoint('Get certified upon completion'),

                  SizedBox(height: 24),

                  // Prerequisites
                  Text(
                    'Prerequisites',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Basic computer skills and motivation to learn',
                    ),
                  ),

                  SizedBox(height: 24),

                  // Course Schedule
                  Text(
                    'Course Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow('Duration', '12 weeks'),
                  _buildDetailRow('Classes/Week', '3 sessions'),
                  _buildDetailRow('Difficulty', 'Intermediate'),
                  _buildDetailRow('Language', 'English'),

                  SizedBox(height: 24),

                  // Reviews Section
                  Text(
                    'Student Reviews',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildReviewCard(
                    'Excellent course!',
                    'Great instructor and well-structured content.',
                    '★★★★★',
                  ),
                  _buildReviewCard(
                    'Very helpful',
                    'Learned a lot of practical skills.',
                    '★★★★☆',
                  ),

                  SizedBox(height: 24),

                  // Enroll Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Toggle enrollment state and persist
                        final newState = !_isEnrolled;
                        setState(() => _isEnrolled = newState);
                        await _db.setCourseEnrollment(widget.course, newState);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isEnrolled
                                  ? 'Enrolled successfully!'
                                  : 'Unenrolled',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _isEnrolled ? Colors.green : primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isEnrolled ? Icons.check : Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          // When not enrolled, color only the word 'Enroll' differently
                          if (_isEnrolled)
                            Text(
                              'Enrolled',
                              style: TextStyle(color: Colors.white),
                            )
                          else
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Enroll',
                                    style: TextStyle(
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' Now'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Related Courses
                  if (_related.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Related Courses',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('See all not implemented'),
                                  ),
                                ),
                            child: Text('See all'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _related.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, idx) {
                          final c = _related[idx];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailsScreen(course: c),
                              ),
                            ),
                            child: Container(
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.network(
                                            c.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons.school,
                                                        size: 48,
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black26,
                                                ],
                                              ),
                                            ),
                                            child: Text(
                                              c.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            c.instructor,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '${c.credits} cr',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small chip used to display metadata like credits or rating.
  Widget _buildInfoChip(String text, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text, style: TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[100],
    );
  }

  /// Row showing a single learning outcome point.
  Widget _buildLearningPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 20, color: Colors.green),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  /// Labeled detail row used for course metadata (duration, difficulty, etc.).
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  /// Small card displaying a student review.
  Widget _buildReviewCard(String title, String content, String rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
              Text(rating, style: TextStyle(color: Colors.amber, fontSize: 12)),
            ],
          ),
          SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
