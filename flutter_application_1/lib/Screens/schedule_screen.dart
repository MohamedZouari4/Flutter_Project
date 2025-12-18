import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/database_service.dart';
import '../widgets/schedule_item.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final DatabaseService _db = DatabaseService();
  String _selectedDay = 'All';

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
}
