import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_planner/time_planner.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class Routine extends StatefulWidget {
  Routine({Key? key}) : super(key: key);

  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  List<TimePlannerTask> tasks = [];
  List<String> week = ['일', '월', '화', '수', '목', '금', '토'];
  String? selectedDay;
  List<Color> cellColors = [
    Colors.redAccent, // 일요일
    Colors.yellow, // 월요일
    Colors.pinkAccent, // 화요일
    Colors.green, // 수요일
    Colors.orange, // 목요일
    Colors.lightBlue, // 금요일
    Colors.orange, // 토요일
  ];
  TextEditingController startHourController =
  TextEditingController(text: '08');
  TextEditingController startMinutesController =
  TextEditingController(text: '00');
  TextEditingController endHourController =
  TextEditingController(text: '24');
  TextEditingController endMinutesController =
  TextEditingController(text: '00');
  TextEditingController taskTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasksFromSharedPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  Future<void> saveTaskToSharedPreferences(TimePlannerTask task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> taskData = {
      'color': task.color!.value,
      'day': task.dateTime.day,
      'hour': task.dateTime.hour,
      'minutes': task.dateTime.minutes,
      'duration': task.minutesDuration,
      'title': task.child != null ? (task.child as Text).data : '',
    };

    List<String>? savedTasks = prefs.getStringList('tasks');

    if (savedTasks == null) {
      savedTasks = [jsonEncode(taskData)];
    } else {
      savedTasks.add(jsonEncode(taskData));
    }

    await prefs.setStringList('tasks', savedTasks);
  }


  void _addObject(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작업 추가'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    setState(() {
                      selectedDay = value.length > 0 ? value[0] : null;
                    });
                  },
                  maxLength: 1,
                  decoration: InputDecoration(
                    labelText: '요일',
                  ),
                ),
                Row(
                  children: [
                    Text('시작 시간: '),
                    Expanded(
                      child: TextField(
                        controller: startHourController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: '시',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text('분: '),
                    Expanded(
                      child: TextField(
                        controller: startMinutesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: '분',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('종료 시간: '),
                    Expanded(
                      child: TextField(
                        controller: endHourController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: '시',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text('분: '),
                    Expanded(
                      child: TextField(
                        controller: endMinutesController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: '분',
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: taskTitleController,
                  decoration: InputDecoration(
                    labelText: '제목',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                int selectedDayNumber = week.indexOf(selectedDay!);

                setState(() {
                  tasks.add(
                    TimePlannerTask(
                      color: cellColors[selectedDayNumber],
                      dateTime: TimePlannerDateTime(
                        day: selectedDayNumber,
                        hour: int.parse(startHourController.text),
                        minutes: int.parse(startMinutesController.text),
                      ),
                      minutesDuration: (int.parse(endHourController.text) - int.parse(startHourController.text)) * 60 +
                          (int.parse(endMinutesController.text) - int.parse(startMinutesController.text)),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(''),
                          ),
                        );
                      },
                      child: Text(taskTitleController.text),
                    ),
                  );
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Success')),
                );

                setState(() {
                  selectedDay = null;
                  startHourController.text = '08';
                  startMinutesController.text = '00';
                  endHourController.text = '24';
                  endMinutesController.text = '00';
                  taskTitleController.clear();
                });

                // 작업을 로컬 파일에 저장
                saveTaskToSharedPreferences(tasks.last);

                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }



  Color getAppBarBackgroundColor() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    if (dayOfWeek == DateTime.monday) {
      return Colors.yellow;
    } else if (dayOfWeek == DateTime.tuesday) {
      return Colors.pinkAccent;
    } else if (dayOfWeek == DateTime.wednesday) {
      return Colors.green;
    } else if (dayOfWeek == DateTime.thursday) {
      return Colors.orange;
    } else if (dayOfWeek == DateTime.friday) {
      return Colors.lightBlue;
    } else if (dayOfWeek == DateTime.saturday) {
      return Colors.orange;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time planner'),
        centerTitle: true,
        backgroundColor: getAppBarBackgroundColor(),
      ),
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
                title: week[i],
                dateStyle: TextStyle(color: cellColors[i]),
              ),
          ],
          tasks: tasks,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addObject(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Time planner Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Routine(),
  ));
}
