import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List week = ['일', '월', '화', '수', '목', '금', '토'];
var kColumnLength = 32;
double kFirstColumnHeight = 20;
double kBoxSize = 60;

Expanded buildTimeColumn() {
  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: kFirstColumnHeight,
        ),
        ...List.generate(
          kColumnLength.toInt(),
              (index) {
            if (index % 2 == 0) {
              return const Divider(
                color: Colors.grey,
                height: 0,
              );
            }
            return SizedBox(
              height: kBoxSize,
              child: Center(child: Text('${index ~/ 2 + 9}')),
            );
          },
        ),
      ],
    ),
  );
}

List<Widget> buildDayColumn(int index, ) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.purple,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Routine(),
    );
  }
}

class Routine extends StatelessWidget {
  const Routine({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: (){
                print("menu button is clicked");
              },
            ),
            title: Text("Weekly Routine"),
            actions: [
              IconButton(
                icon: Icon(Icons.stars),
                onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RoutineAdd()),
                  );
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.all(10),
              height: kColumnLength / 2 * kBoxSize + kColumnLength,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  buildTimeColumn(),
                  ...buildDayColumn(0),
                  ...buildDayColumn(1),
                  ...buildDayColumn(2),
                  ...buildDayColumn(3),
                  ...buildDayColumn(4),
                  ...buildDayColumn(5),
                  ...buildDayColumn(6),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(),
        )
    );
  }
}

class RoutineAdd extends StatelessWidget {
  const RoutineAdd({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoutineModel routineModel = RoutineModel(
      title: '',
      day: '일요일',
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.now(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          RoutineTitle(
            onTitleChanged: (title) {
              routineModel.title = title;
            },
          ),
          DropDownPage(
            onDayChanged: (dropDownValue) {
              routineModel.day = dropDownValue;
            },
          ),
          STimePicker(
            onTimeChanged: (startTime) {
              routineModel.startTime = startTime;
            },
          ),
          ETimePicker(
            onTimeChanged: (endTime) {
              routineModel.endTime = endTime;
            },
          ),
          ElevatedButton(
            onPressed: () {
              print('제목: ${routineModel.title}');
              print('요일: ${routineModel.day}');
              print('시작 시간: ${routineModel.startTime}');
              print('종료 시간: ${routineModel.endTime}');
            },
          child: Text('루틴 저장'),
          ),
        ],
      ),
    );
  }
}

class RoutineModel {
  String title;
  String day;
  TimeOfDay startTime;
  TimeOfDay endTime;

  RoutineModel({
    required this.title,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}

class RoutineTitle extends StatelessWidget {
  RoutineTitle({Key? key, required this.onTitleChanged}) : super(key: key);
  final Function(String) onTitleChanged;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(border: OutlineInputBorder()),
      controller: myController,
      onChanged: (title) {
        onTitleChanged(title);
      },
    );
  }
}

class DropDownPage extends StatefulWidget {
  const DropDownPage({Key? key, required this.onDayChanged}) : super(key: key);
  final Function(String) onDayChanged;

  @override
  State<DropDownPage> createState() => _DropDownPageState();
}

class _DropDownPageState extends State<DropDownPage> {
  String dropDownValue = "일요일";

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dropDownValue),
          _buildArea(),
        ]
    );
  }

  Widget _buildArea() {
    List<String> dropDownList = [
      '일요일',
      '월요일',
      '화요일',
      '수요일',
      '목요일',
      '금요일',
      '토요일'
    ];

    return DropdownButton(
      value: dropDownValue,
      items: dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropDownValue = value!;
          widget.onDayChanged(value);
        });
      },
    );
  }
}

class STimePicker extends StatefulWidget {
  const STimePicker({Key? key, required this.onTimeChanged}) : super(key: key);
  final Function(TimeOfDay) onTimeChanged;

  @override
  State<STimePicker> createState() => _STimePickerState();
}

class _STimePickerState extends State<STimePicker> {
  TimeOfDay initialTimeS = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('시작 시간 입력'),
        Text(
          '${initialTimeS.hour}:${initialTimeS.minute}',
          style: TextStyle(fontSize: 40),
        ),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? timeOfDay = await showTimePicker(
              context: context,
              initialTime: initialTimeS,
              initialEntryMode: TimePickerEntryMode.inputOnly,
            );
            if (timeOfDay != null) {
              setState(() {
                initialTimeS = timeOfDay;
                widget.onTimeChanged(timeOfDay); // 새로운 시작 시간을 상위 위젯에 전달
              });
            }
          },
          child: Text('TimePicker'),
        ),
      ],
    );
  }
}


