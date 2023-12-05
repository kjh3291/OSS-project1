import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/time_planner.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
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
  String selectedDay = '일';
  List<Color> cellColors = [
    Colors.lightBlueAccent,
    Colors.yellow,
    Colors.pinkAccent,
    Colors.green,
    Colors.orange,
    Colors.lightBlueAccent,
    Colors.orange,
  ];
  int selectedDayIndex = 0;
  int selectedStartHour = 8;
  int selectedStartMinutes = 0;
  int selectedEndHour = 23;
  int selectedEndMinutes = 0;
  String taskTitle = '';

  void _addObject(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작업 추가'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('요일 선택'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: week.map((String day) {
                                return ListTile(
                                  title: Text(day),
                                  onTap: () {
                                    setState(() {
                                      selectedDayIndex = week.indexOf(day);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            week[selectedDayIndex],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('시작 시간: '),
                    DropdownButton<int>(
                      value: selectedStartHour,
                      onChanged: (int? value) {
                        setState(() {
                          selectedStartHour = value!;
                        });
                      },
                      items: List.generate(24, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index시'),
                        );
                      }),
                    ),
                    SizedBox(width: 16),
                    Text('분: '),
                    DropdownButton<int>(
                      value: selectedStartMinutes,
                      onChanged: (int? value) {
                        setState(() {
                          selectedStartMinutes = value!;
                        });
                      },
                      items: List.generate(60, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index분'),
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('종료 시간: '),
                    DropdownButton<int>(
                      value: selectedEndHour,
                      onChanged: (int? value) {
                        setState(() {
                          selectedEndHour = value!;
                        });
                      },
                      items: List.generate(24, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index시'),
                        );
                      }),
                    ),
                    SizedBox(width: 16),
                    Text('분: '),
                    DropdownButton<int>(
                      value: selectedEndMinutes,
                      onChanged: (int? value) {
                        setState(() {
                          selectedEndMinutes = value!;
                        });
                      },
                      items: List.generate(60, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('$index분'),
                        );
                      }),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '제목'),
                  onChanged: (value) {
                    setState(() {
                      taskTitle = value;
                    });
                  },
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
                int selectedDayNumber = selectedDayIndex;

                setState(() {
                  tasks.add(
                    TimePlannerTask(
                      color: Colors.purple,
                      dateTime: TimePlannerDateTime(
                        day: selectedDayNumber,
                        hour: selectedStartHour,
                        minutes: selectedStartMinutes,
                      ),
                      minutesDuration: (selectedEndHour - selectedStartHour) * 60 +
                          (selectedEndMinutes - selectedStartMinutes),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(''),
                          ),
                        );
                      },
                      child: Text(taskTitle),
                    ),
                  );
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Success')),
                );

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
          setTimeOnAxis: false,
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
    scrollBehavior: MyCustomScrollBehavior(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Routine(),
  ));
}
