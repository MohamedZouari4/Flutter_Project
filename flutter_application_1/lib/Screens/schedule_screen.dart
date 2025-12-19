// File: lib/Screens/schedule_screen.dart
// Screen showing user's schedule; provides filtering by day.

import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/hive_service.dart';
import '../widgets/schedule_item.dart';

/// Shows scheduled classes and allows day filtering.
class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Use Hive-backed service for data persistence
  final HiveService _db = HiveService();
  String _selectedDay = 'All';

  /// Ensures some sample schedules exist for demo purposes.
  Future<void> _ensureSeedSchedules() async {
    final schedules = await _db.getSchedules();
    if (schedules.isEmpty) {
      final sampleSchedules = [
        Schedule(
          courseName: 'Introduction to CS',
          day: 'Monday',
          startTime: '09:00',
          endTime: '10:30',
          room: 'Room 101',
          color: '#FF7043',
        ),
        Schedule(
          courseName: 'Data Structures',
          day: 'Monday',
          startTime: '11:00',
          endTime: '12:30',
          room: 'Room 202',
          color: '#42A5F5',
        ),
        Schedule(
          courseName: 'Web Development',
          day: 'Tuesday',
          startTime: '09:00',
          endTime: '10:30',
          room: 'Lab 301',
          color: '#AB47BC',
        ),
        Schedule(
          courseName: 'Database Systems',
          day: 'Wednesday',
          startTime: '10:00',
          endTime: '11:30',
          room: 'Room 105',
          color: '#29B6F6',
        ),
        Schedule(
          courseName: 'Mobile Development',
          day: 'Thursday',
          startTime: '09:00',
          endTime: '10:30',
          room: 'Lab 250',
          color: '#66BB6A',
        ),
        Schedule(
          courseName: 'Cloud Computing',
          day: 'Friday',
          startTime: '14:00',
          endTime: '15:30',
          room: 'Room 404',
          color: '#FFA726',
        ),
      ];
      for (var schedule in sampleSchedules) {
        await _db.insertSchedule(schedule);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _ensureSeedSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Schedule'), elevation: 0),
      // Add button to create new schedules
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddScheduleDialog,
        tooltip: 'Add schedule',
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Schedule>>(
        future: _db.getSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No schedule yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            );
          }
          final schedules = snapshot.data!;
          // Filter schedules by the selected day; 'All' shows everything
          final filtered = _selectedDay == 'All'
              ? schedules
              : schedules.where((s) => s.day == _selectedDay).toList();

          return Column(
            children: [
              SizedBox(height: 12),
              // Day selector chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children:
                      [
                            'All',
                            'Monday',
                            'Tuesday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                          ]
                          .map(
                            (d) => Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(d),
                                selected: _selectedDay == d,
                                // Selecting a day triggers a state update and re-filter
                                onSelected: (_) =>
                                    setState(() => _selectedDay = d),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              SizedBox(height: 12),
              // Legend
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(width: 12, height: 12, color: Color(0xFFFF7043)),
                    SizedBox(width: 8),
                    Text('Core Courses'),
                    SizedBox(width: 16),
                    Container(width: 12, height: 12, color: Color(0xFF42A5F5)),
                    SizedBox(width: 8),
                    Text('Lectures'),
                    SizedBox(width: 16),
                    Container(width: 12, height: 12, color: Color(0xFF66BB6A)),
                    SizedBox(width: 8),
                    Text('Labs'),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      ScheduleItem(schedule: filtered[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Shows a dialog to add a new schedule entry.
  Future<void> _showAddScheduleDialog() async {
    final courseController = TextEditingController();
    final roomController = TextEditingController();
    String day = 'Monday';
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String selectedColor = '#FF7043';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickStart() async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: 9, minute: 0),
              );
              if (t != null) setState(() => startTime = t);
            }

            Future<void> pickEnd() async {
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: 10, minute: 30),
              );
              if (t != null) setState(() => endTime = t);
            }

            return AlertDialog(
              title: Text('Add Schedule'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: courseController,
                      decoration: InputDecoration(labelText: 'Course name'),
                    ),
                    DropdownButtonFormField<String>(
                      value: day,
                      items:
                          [
                                'Monday',
                                'Tuesday',
                                'Wednesday',
                                'Thursday',
                                'Friday',
                              ]
                              .map(
                                (d) =>
                                    DropdownMenuItem(value: d, child: Text(d)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => day = v ?? 'Monday'),
                      decoration: InputDecoration(labelText: 'Day'),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: pickStart,
                            child: Text(
                              startTime == null
                                  ? 'Start time'
                                  : startTime!.format(context),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: pickEnd,
                            child: Text(
                              endTime == null
                                  ? 'End time'
                                  : endTime!.format(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: roomController,
                      decoration: InputDecoration(labelText: 'Room'),
                    ),
                    SizedBox(height: 8),
                    // Simple color choices
                    Wrap(
                      spacing: 8,
                      children:
                          [
                            '#FF7043',
                            '#42A5F5',
                            '#66BB6A',
                            '#AB47BC',
                            '#FFA726',
                          ].map((hex) {
                            final selected = hex == selectedColor;
                            return ChoiceChip(
                              label: Text(''),
                              selected: selected,
                              backgroundColor: Color(
                                int.parse(hex.replaceFirst('#', '0xFF')),
                              ),
                              onSelected: (_) =>
                                  setState(() => selectedColor = hex),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (courseController.text.trim().isEmpty ||
                        startTime == null ||
                        endTime == null) {
                      // simple validation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please complete course and times'),
                        ),
                      );
                      return;
                    }
                    final s = Schedule(
                      courseName: courseController.text.trim(),
                      day: day,
                      startTime: startTime!.format(context),
                      endTime: endTime!.format(context),
                      room: roomController.text.trim(),
                      color: selectedColor,
                    );
                    await _db.insertSchedule(s);
                    setState(() {}); // refresh dialog state
                    Navigator.pop(context);
                    // Rebuild main screen
                    this.setState(() {});
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
