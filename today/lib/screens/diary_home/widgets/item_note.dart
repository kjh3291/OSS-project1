import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemNote extends StatelessWidget {
  const ItemNote({
    Key? key,
    required this.title,
    required this.content,
    required this.selectedDate,
  }) : super(key: key);

  final String title;
  final String content;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    List<String> noteInfo = _getNoteInfo();
    String formattedDate = noteInfo[0];
    String day = noteInfo[1];
    String year = noteInfo[2];
    String weekday = noteInfo[3];

    Color noteColor = _getNoteColor(weekday);

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
            offset: const Offset(0, 3),
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

  List<String> _getNoteInfo() {
    String formattedDate = DateFormat('MMM', 'ko').format(selectedDate);
    String day = DateFormat('dd').format(selectedDate);
    String year = DateFormat('yyyy년', 'ko').format(selectedDate);
    String weekday = DateFormat('EEEE', 'ko').format(selectedDate);

    return [formattedDate, day, year, weekday];
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
    final String title = json['title'];
    final String content = json['content'];
    final DateTime selectedDate = DateTime(
      int.parse(json['year']),
      int.parse(json['month']),
      int.parse(json['day']),
    );

    return ItemNote(
      title: title,
      content: content,
      selectedDate: selectedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'year': DateFormat('yyyy').format(selectedDate),
      'month': DateFormat('MM').format(selectedDate),
      'day': DateFormat('dd').format(selectedDate),
      'weekday': DateFormat('EEEE', 'ko').format(selectedDate),
    };
  }
}
