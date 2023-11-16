import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemNote extends StatelessWidget {
  const ItemNote({
    Key? key,
    required this.title,
    required this.content,
    required this.now, // 생성될 당시의 년도, 날짜, 요일을 저장하는 변수
  }) : super(key: key);

  final String title;
  final String content;
  final DateTime now; // 생성될 당시의 년도, 날짜, 요일을 저장하는 변수

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM', 'ko').format(now); // 한국어로 월 표시
    String day = DateFormat('dd').format(now);
    String year = DateFormat('yyyy년', 'ko').format(now); // 한국어로 년도 표시
    String weekday = DateFormat('EEEE', 'ko').format(now); // 한국어로 요일 표시

    Color noteColor = _getNoteColor(weekday); // 요일에 해당하는 색상 가져오기

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // 그림자의 위치 조정
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: noteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  formattedDate.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  day,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  year,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  weekday,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNoteColor(String weekday) {
    Map<String, Color> colorMapping = {
      '월요일': Colors.yellow,
      '화요일': Colors.pinkAccent,
      '수요일': Colors.green,
      '목요일': Colors.orange,
      '금요일': Colors.lightBlue,
      '토요일': Colors.orange,
      '일요일': Colors.redAccent,
    };

    return colorMapping[weekday] ?? Colors.blue;
  }

  factory ItemNote.fromJson(Map<String, dynamic> json) {
    final String title = json['title'] as String;
    final String content = json['content'] as String;
    final String year = json['year'] as String;
    final String month = json['month'] as String;
    final String day = json['day'] as String;
    final String hour = json['hour'] as String;
    final String minute = json['minute'] as String;
    final DateTime now = DateTime(int.parse(year), int.parse(month), int.parse(day), int.parse(hour), int.parse(minute));

    return ItemNote(
      title: title,
      content: content,
      now: now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'year': DateFormat('yyyy').format(now),
      'month': DateFormat('MM').format(now),
      'day': DateFormat('dd').format(now),
      'hour': DateFormat('HH').format(now),
      'minute': DateFormat('mm').format(now),
    };
  }
}
