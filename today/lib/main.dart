import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:today/screens/diary_home/home_screens.dart';
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
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE', 'ko_KR').format(now); // 요일
    final formattedDate = DateFormat('yyyy년/MM/dd/($weekday)', 'ko_KR').format(now); // 년도, 날짜, 요일

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(formattedDate, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Center(
        child: const Text('중단'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Colors.black),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black),
            label: '다이어리',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, color: Colors.black),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black),
            label: '설정',
          ),
        ],
        currentIndex: 1, // 두 번째 버튼 아이콘에 DiaryScreen 연결
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiaryScreen(),
              ),
            );
          }
        },
        selectedItemColor: Colors.black, // 선택된 아이템의 색상
        unselectedItemColor: Colors.black, // 선택되지 않은 아이템의 색상
      ),
    );
  }
}
