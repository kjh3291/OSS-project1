import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_planner/time_planner.dart';

class DisplayTasksPage extends StatefulWidget {
  @override
  _DisplayTasksPageState createState() => _DisplayTasksPageState();
}

class _DisplayTasksPageState extends State<DisplayTasksPage> {
  List<TimePlannerTask> tasks = [];

  int startHour = 8; // 시작 시간
  int endHour = 23; // 종료 시간

  @override
  void initState() {
    super.initState();
    loadTasksFromSharedPreferences();
  }

  Future<void> loadTasksFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');

    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((taskData) {
          Map<String, dynamic> taskMap = jsonDecode(taskData);
          return TimePlannerTask(
            color: Color(taskMap['color']),
            dateTime: TimePlannerDateTime(
              day: taskMap['day'],
              hour: taskMap['hour'],
              minutes: taskMap['minutes'],
            ),
            minutesDuration: taskMap['duration'],
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(''),
                ),
              );
            },
            child: Text(taskMap['title']),
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TimePlanner(
          startHour: 8,
          endHour: 23,
          use24HourFormat: true,
          setTimeOnAxis: true,
          style: TimePlannerStyle(
            cellWidth: 60,
            cellHeight: 60,
            showScrollBar: true,
          ),
          headers: [
            for (int i = 0; i < 7; i++)
              TimePlannerTitle(
                title: ['일', '월', '화', '수', '목', '금', '토'][i],
                dateStyle: TextStyle(
                  color: [Colors.redAccent, Colors.yellow, Colors.pinkAccent, Colors.green, Colors.orange, Colors.lightBlue, Colors.orange][i],
                ),
              ),
          ],
          tasks: tasks,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Display Tasks',
    home: DisplayTasksPage(),
  ));
}
