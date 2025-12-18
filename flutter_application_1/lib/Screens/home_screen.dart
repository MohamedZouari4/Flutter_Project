import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/database_service.dart';
import '../widgets/course_card.dart';
import 'course_details_screen.dart';
import 'profile_screen.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
              'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400',
          credits: 3,
        ),
        Course(
          title: 'Data Structures & Algorithms',
          description:
              'Master data structures and optimize algorithms for better software.',
          instructor: 'Prof. Michael Johnson',
          imageUrl:
              'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400',
          credits: 4,
        ),
        Course(
          title: 'Web Development Bootcamp',
          description:
              'Build responsive web applications using HTML, CSS, JavaScript, and React.',
          instructor: 'Dr. Emily Chen',
          imageUrl:
              'https://images.unsplash.com/photo-1633356122544-f134324ef6db?w=400',
          credits: 4,
        ),
        Course(
          title: 'Database Systems',
          description:
              'Design and manage databases using SQL and NoSQL technologies.',
          instructor: 'Prof. James Wilson',
          imageUrl:
              'https://images.unsplash.com/photo-1516321497487-e288fb19713f?w=400',
          credits: 3,
        ),
        Course(
          title: 'Mobile App Development',
          description:
              'Create mobile applications with Flutter and modern frameworks.',
          instructor: 'Dr. Lisa Rodriguez',
          imageUrl:
              'https://images.unsplash.com/photo-1512941691920-25bda36fda6d?w=400',
          credits: 4,
        ),
        Course(
          title: 'Cloud Computing & DevOps',
          description:
              'Deploy and manage applications on AWS, Google Cloud, and Azure.',
          instructor: 'Prof. David Brown',
          imageUrl:
              'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400',
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
              child: FutureBuilder<List<Course>>(
                future: _db.getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No courses available'));
                  }

                  final courses = snapshot.data!;
                  final filtered = courses.where((c) {
                    if (_searchQuery.isEmpty) return true;
                    final s = '${c.title} ${c.instructor} ${c.description}'
                        .toLowerCase();
                    return s.contains(_searchQuery);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CourseDetailsScreen(course: c),
                                    ),
                                  ),
                                  child: CourseCard(course: c, onTap: () {}),
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
