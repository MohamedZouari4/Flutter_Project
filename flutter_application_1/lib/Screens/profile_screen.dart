// File: lib/Screens/profile_screen.dart
// User profile view and settings page.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/hive_service.dart';
import '../models/user.dart';
import 'login_screen.dart';

/// Displays basic user profile information stored locally.
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _email;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// Loads saved user info from SharedPreferences.
  /// Loads user values from SharedPreferences into state for display.
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');
    if (email == null) return;

    // Load persistent user record from Hive if available
    final user = await HiveService().findUserByEmail(email);

    if (!mounted) return;
    setState(() {
      _email = email;
      _user = user;
    });
  }

  /// Clears session data and navigates back to the login screen.
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userEmail');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () {
              // placeholder: navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: primary),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _email ?? 'student@university.edu',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Chip(
                                label: Text('Honor Student'),
                                backgroundColor: Colors.white24,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              Chip(
                                label: Text('Mentor'),
                                backgroundColor: Colors.white24,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard('6', 'Courses', primary)),
                  SizedBox(width: 12),
                  Expanded(child: _buildStatCard('18', 'Credits', primary)),
                  SizedBox(width: 12),
                  Expanded(child: _buildStatCard('3.8', 'GPA', primary)),
                ],
              ),

              SizedBox(height: 24),

              // Profile Info Section
              Text(
                'Account Information',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              _buildInfoTile(
                'Student ID',
                _user?.studentId ?? '2024001',
                Icons.badge,
              ),
              _buildInfoTile(
                'Major',
                _user?.major ?? 'Computer Science',
                Icons.school,
              ),
              _buildInfoTile(
                'Year',
                _user?.year ?? 'Junior',
                Icons.calendar_today,
              ),
              _buildInfoTile(
                'Phone',
                _user?.phone ?? '+1 (555) 000-0000',
                Icons.phone,
              ),

              SizedBox(height: 24),

              // Settings Section
              Text(
                'Settings',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              ListTile(
                leading: Icon(Icons.notifications, color: primary),
                title: Text('Notifications'),
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
              ListTile(
                leading: Icon(Icons.visibility, color: primary),
                title: Text('Dark Mode'),
                trailing: Switch(value: false, onChanged: (_) {}),
              ),

              SizedBox(height: 24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) _logout();
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Small stat card used in the profile view to show metrics like courses/credits/GPA.
  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  /// Reusable row showing a labeled piece of account information with an icon.
  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
