import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:today/screens/diary_home/home_screens.dart';
import 'package:today/todolist/ToDoList.dart';
import 'Routine/routine.dart';
import 'calendar/calendar_screen.dart';

void main() {
  initializeDateFormatting('ko_KR').then((_) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '다른 하루들',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'KCC-Ganpan', // 'KCC-Ganpan' 폰트 적용
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
    final now = DateTime.now();
    final weekday = DateFormat('EEEE', 'ko_KR').format(now);
    final formattedDate = DateFormat('yyyy년/MM/dd/($weekday)', 'ko_KR').format(now);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getAppBarBackgroundColor(),
        title: Row(
          children: [
            Text(formattedDate, style: TextStyle(color: Colors.black, fontFamily: 'KCC-Ganpan')), // 'KCC-Ganpan' 폰트 적용
          ],
        ),
      ),
      body: Center(
        child: const Text('중단', style: TextStyle(fontFamily: 'KCC-Ganpan')), // 'KCC-Ganpan' 폰트 적용
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alarm_rounded, color: Colors.black),
            label: '',
          ),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiaryScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarScreen(),
              ),
            );
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToDoList(),
              ),
            );
          }
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => routine(),
              ),
            );
          }
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
