import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:today/screens/diary_home/home_screens.dart';

void main() {
  initializeDateFormatting('ko_KR').then((_) { // 한국어 로케일 데이터 초기화
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
      home: const DiaryScreen(),
    );
  }
}
