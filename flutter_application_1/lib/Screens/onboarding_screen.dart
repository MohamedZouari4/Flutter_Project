import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to EduHub',
      'description':
          'Your ultimate platform for online learning and course management. Access courses from top instructors anytime, anywhere.',
      'icon': Icons.school,
      'color': Color(0xFF1E3A8A),
    },
    {
      'title': 'Discover Courses',
      'description':
          'Browse through hundreds of courses across multiple disciplines. From Computer Science to Data Analytics, find what interests you.',
      'icon': Icons.library_books,
      'color': Color(0xFF42A5F5),
    },
    {
      'title': 'Manage Your Schedule',
      'description':
          'Keep track of your class schedules, assignments, and deadlines. Never miss an important date.',
      'icon': Icons.calendar_month,
      'color': Color(0xFFAB47BC),
    },
    {
      'title': 'Track Progress',
      'description':
          'Monitor your academic performance with detailed analytics. View grades, completion rates, and learning progress.',
      'icon': Icons.trending_up,
      'color': Color(0xFF29B6F6),
    },
    {
      'title': 'Get Started!',
      'description':
          'Join thousands of students already learning on EduHub. Create your account and start your learning journey today.',
      'icon': Icons.rocket,
      'color': Color(0xFF66BB6A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (page['color'] as Color).withOpacity(0.1),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: (page['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              page['icon'],
                              size: 60,
                              color: page['color'],
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(
                            page['title']!,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            page['description']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? _pages[index]['color']
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == _pages.length - 1) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pages[_currentPage]['color'],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
