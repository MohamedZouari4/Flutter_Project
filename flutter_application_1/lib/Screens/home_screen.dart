import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/course.dart';
import '../services/hive_service.dart';
import '../widgets/course_card.dart';
import 'course_details_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';

/// Home screen showing featured courses and search.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use Hive-backed service for data persistence
  final HiveService _db = HiveService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  /// Ensures the DB has seed course data for the demo UI.
  Future<void> _ensureSeedData() async {
    final courses = await _db.getCourses();
    if (courses.isEmpty) {
      final sampleCourses = [
        Course(
          title: 'Introduction to Computer Science',
          description:
              'Learn the fundamentals of programming, algorithms, and problem-solving.',
          instructor: 'Dr. Sarah Smith',
          imageUrl:
              'https://images.unsplash.com/photo-1517433456452-f9633a875f6f?w=800',
          credits: 3,
        ),
        Course(
          title: 'Data Structures & Algorithms',
          description:
              'Master data structures and optimize algorithms for better software.',
          instructor: 'Prof. Michael Johnson',
          imageUrl:
              'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800',
          credits: 4,
        ),
        Course(
          title: 'Web Development Bootcamp',
          description:
              'Build responsive web applications using HTML, CSS, JavaScript, and React.',
          instructor: 'Dr. Emily Chen',
          imageUrl:
              'https://images.unsplash.com/photo-1520975909142-2b3f4d4b7d6e?w=800',
          credits: 4,
        ),
        Course(
          title: 'Database Systems',
          description:
              'Design and manage databases using SQL and NoSQL technologies.',
          instructor: 'Prof. James Wilson',
          imageUrl:
              'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
          credits: 3,
        ),
        Course(
          title: 'Mobile App Development',
          description:
              'Create mobile applications with Flutter and modern frameworks.',
          instructor: 'Dr. Lisa Rodriguez',
          imageUrl:
              'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800',
          credits: 4,
        ),
        Course(
          title: 'Cloud Computing & DevOps',
          description:
              'Deploy and manage applications on AWS, Google Cloud, and Azure.',
          instructor: 'Prof. David Brown',
          imageUrl:
              'https://images.unsplash.com/photo-1504805572947-34fad45aed93?w=800',
          credits: 3,
        ),
        Course(
          title: 'Artificial Intelligence',
          description:
              'Explore machine learning models, neural networks, and AI ethics.',
          instructor: 'Dr. Alan Turing',
          imageUrl:
              'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
          credits: 4,
        ),
        Course(
          title: 'Human-Computer Interaction',
          description:
              'Design usable interfaces and learn user research techniques.',
          instructor: 'Prof. Karen Miller',
          imageUrl:
              'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
          credits: 3,
        ),
        Course(
          title: 'Cybersecurity Basics',
          description:
              'Learn the fundamentals of securing systems and networks.',
          instructor: 'Dr. Samuel Lee',
          imageUrl:
              'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800',
          credits: 3,
        ),
        Course(
          title: 'Data Visualization',
          description:
              'Turn data into insights using charts, dashboards, and storytelling.',
          instructor: 'Dr. Ana Gomez',
          imageUrl:
              'https://images.unsplash.com/photo-1500856056008-859079534e9e?w=800',
          credits: 3,
        ),
        Course(
          title: 'Game Development',
          description:
              'Build interactive games using Unity and modern game engines.',
          instructor: 'Prof. Marcus Wright',
          imageUrl:
              'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
          credits: 4,
        ),
        Course(
          title: 'Software Engineering Practices',
          description:
              'Study software lifecycle, testing, CI/CD, and team workflows.',
          instructor: 'Dr. Olivia Park',
          imageUrl:
              'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800',
          credits: 3,
        ),
      ];
      for (var course in sampleCourses) {
        await _db.insertCourse(course);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _ensureSeedData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Superior University'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScheduleScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Student',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),

            SizedBox(height: 14),
            // Search bar
            TextField(
              controller: _searchController,
              onChanged: (v) =>
                  setState(() => _searchQuery = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search courses, instructors... ',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: ValueListenableBuilder<Box<Course>>(
                valueListenable: Hive.box<Course>('courses').listenable(),
                builder: (context, box, _) {
                  final courses = box.values.toList();
                  if (courses.isEmpty) {
                    return Center(child: Text('No courses available'));
                  }

                  // Apply simple text filter over title, instructor and description
                  final filtered = courses.where((c) {
                    if (_searchQuery.isEmpty) return true;
                    final s = '${c.title} ${c.instructor} ${c.description}'
                        .toLowerCase();
                    return s.contains(_searchQuery);
                  }).toList();

                  final saved = courses.where((c) => c.isSaved).toList();
                  final enrolled = courses.where((c) => c.isEnrolled).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Saved courses
                      if (saved.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Saved Courses',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Manage saved not implemented',
                                        ),
                                      ),
                                    ),
                                child: Text('Manage'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: saved.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12),
                            itemBuilder: (context, idx) {
                              final c = saved[idx];
                              return SizedBox(
                                width: 260,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CourseDetailsScreen(course: c),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            c.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, e, s) =>
                                                Container(
                                                  color: Colors.grey[200],
                                                  child: Icon(Icons.school),
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        c.title,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        c.instructor,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await _db.setCourseSaved(
                                                      c,
                                                      false,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.bookmark_remove,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                      ],

                      // Enrolled courses
                      if (enrolled.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Enrolled Courses',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Manage not implemented'),
                                      ),
                                    ),
                                child: Text('Manage'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: enrolled.length,
                            separatorBuilder: (_, __) => SizedBox(width: 12),
                            itemBuilder: (context, idx) {
                              final c = enrolled[idx];
                              return SizedBox(
                                width: 260,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CourseDetailsScreen(course: c),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            c.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, e, s) =>
                                                Container(
                                                  color: Colors.grey[200],
                                                  child: Icon(Icons.school),
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        c.title,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      SizedBox(height: 6),
                                                      Text(
                                                        c.instructor,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await _db
                                                        .setCourseEnrollment(
                                                          c,
                                                          false,
                                                        );
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                      ],

                      // Featured carousel
                      if (courses.isNotEmpty) ...[
                        SizedBox(
                          height: 180,
                          child: PageView.builder(
                            controller: PageController(viewportFraction: 0.85),
                            itemCount: courses.length.clamp(0, 5),
                            itemBuilder: (context, i) {
                              final c = courses[i];
                              return Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: CourseCard(
                                  course: c,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CourseDetailsScreen(course: c),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                      ],

                      // Categories
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip('All', Icons.grid_view),
                            SizedBox(width: 8),
                            _buildCategoryChip('Computer Science', Icons.code),
                            SizedBox(width: 8),
                            _buildCategoryChip('Web', Icons.web),
                            SizedBox(width: 8),
                            _buildCategoryChip('Mobile', Icons.smartphone),
                            SizedBox(width: 8),
                            _buildCategoryChip('Data', Icons.bar_chart),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),

                      // Course list
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final course = filtered[index];
                            return CourseCard(
                              course: course,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CourseDetailsScreen(course: course),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small chip used for category filtering (UI placeholder).
  Widget _buildCategoryChip(String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: Colors.white70),
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () {
        // placeholder: could filter by category
      },
    );
  }
}
