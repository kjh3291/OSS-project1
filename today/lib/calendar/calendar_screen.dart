import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDate;
  TextEditingController _textEditingController = TextEditingController();
  bool isContainerVisible = false;
  List<String> savedNotes = [];
  bool isListVisible = false;
  bool showWarning = false;

  @override
  void initState() {
    super.initState();
    getSavedNotes();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> saveNoteToSharedPreferences(DateTime date, String text) async {
    if (text.isEmpty) {
      setState(() {
        showWarning = true;
      });
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList(date.toString()) ?? [];
    notes.add(text);
    await prefs.setStringList(date.toString(), notes);
    setState(() {
      savedNotes = notes;
      showWarning = false;
    });
  }

  Future<void> getSavedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList(selectedDate.toString()) ?? [];
    setState(() {
      savedNotes = notes;
      isListVisible = notes.isNotEmpty;
      isContainerVisible = !isListVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isListVisible = false;
          isContainerVisible = false; // 컨테이너 숨기기
        });
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Container(
              child: CalendarCarousel(
                // 캘린더 옵션 설정
                weekendTextStyle: TextStyle(color: Colors.red),
                thisMonthDayBorderColor: Colors.grey,
                daysHaveCircularBorder: false,
                // 캘린더 이벤트 핸들러
                onDayPressed: (DateTime date, List<dynamic> events) {
                  setState(() {
                    selectedDate = date;
                    isContainerVisible = true;
                    _textEditingController.text = '';
                    getSavedNotes();
                  });
                },
              ),
            ),
            if (isContainerVisible)
              Center(
                child: Container(
                  width: 500.0,
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '일정 추가',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text('선택된 날짜: ${selectedDate?.toString().split(' ')[0] ?? ''}'),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          hintText: '일정을 작성해주세요.',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                      ),
                      SizedBox(height: 16.0),
                      if (showWarning)
                        Text(
                          '일정을 작성해주세요.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          String text = _textEditingController.text;
                          saveNoteToSharedPreferences(selectedDate!, text);
                          if (!showWarning) {
                            setState(() {
                              _textEditingController.clear(); // TextField 내용 지우기
                              isContainerVisible = false;
                              isListVisible = true;
                            });
                          }
                        },
                        child: Text('저장'),
                      ),
                    ],
                  ),
                ),
              ),
            if (isListVisible)
              Positioned(
                top: 200.0,
                left: 16.0,
                right: 16.0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '저장된 일정',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: savedNotes.length,
                        itemBuilder: (context, index) {
                          String note = savedNotes[index];
                          return ListTile(
                            title: Text(note),
                            onTap: () {
                              // 일정 수정 로직을 추가하세요
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isContainerVisible = true;
                            isListVisible = false;
                          });
                        },
                        child: Text('일정 추가하기'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
