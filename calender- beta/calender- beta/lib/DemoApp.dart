import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';


class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {

  late DateTime selectedDay = DateTime.now();
  late List <CleanCalendarEvent> selectedEvent;



  final Map<DateTime,List<CleanCalendarEvent>> events = {
    DateTime (DateTime.now().year,DateTime.now().month,DateTime.now().day):
        [
          CleanCalendarEvent('Event A',
          startTime: DateTime(
              DateTime.now().year,DateTime.now().month,DateTime.now().day,10,0),
            endTime:  DateTime(
                DateTime.now().year,DateTime.now().month,DateTime.now().day,12,0),
            description: 'A special event',
            color: Colors.blue),
        ],

    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2):
    [
      CleanCalendarEvent('Event B',
          startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 10, 0),
          endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 12, 0),
          color: Colors.orange),
      CleanCalendarEvent('Event C',
          startTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 14, 30),
          endTime: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 2, 17, 0),
          color: Colors.pink),
    ],
  };

  void _handleData(date){
    setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });
    print(selectedDay);
  }
  @override
  void initState() {
    // TODO: implement initState
    selectedEvent = events[selectedDay] ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Calendar(
            startOnMonday: true,
            selectedColor: Colors.blue,
            todayColor: Colors.red,
            eventColor: Colors.green,
            eventDoneColor: Colors.amber,
            bottomBarColor: Colors.deepOrange,
            onRangeSelected: (range) {
              print('selected Day ${range.from},${range.to}');
            },
            onDateSelected: (date) {
              return _handleData(date);
            },
            events: events,
            isExpanded: true,
            dayOfWeekStyle: TextStyle(
              fontSize: 15,
              color: Colors.black12,
              fontWeight: FontWeight.w100,
            ),
            bottomBarTextStyle: TextStyle(
              color: Colors.white,
            ),
            hideBottomBar: false,
            hideArrows: false,
            weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              DateTime? startTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );

              if (startTime == null) return; // 사용자가 취소를 누른 경우

              String eventName = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('이벤트 이름을 입력하세요'),
                  content: TextField(
                    onSubmitted: (value) => Navigator.pop(context, value),
                  ),
                ),
              );
              if (eventName == null) return; // 사용자가 취소를 누른 경우

              // 새로운 이벤트를 생성하고 이를 events 맵에 추가합니다.
              DateTime eventKey = DateTime(startTime.year, startTime.month, startTime.day);
              CleanCalendarEvent newEvent = CleanCalendarEvent(
                eventName,
                startTime: startTime,
                endTime: startTime.add(Duration(hours: 1)), 
                color: Colors.green,
              );

              if (events[eventKey] != null) {
                events[eventKey]!.add(newEvent);
              } else {
                events[eventKey] = [newEvent];
              }

              // 화면을 갱신
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10), // 두 버튼 사이에 간격을 추가합니다.
          FloatingActionButton(
            onPressed: () async {
              if (selectedEvent.isEmpty) return; // 선택된 이벤트가 없는 경우

              // 삭제할 이벤트를 선택하게 하는 대화 상자를 표시합니다.
              CleanCalendarEvent? eventToDelete = await showDialog<CleanCalendarEvent>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text('삭제할 이벤트를 선택하세요'),
                  children: selectedEvent.map((event) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, event),
                    child: Text(event.summary),
                  )).toList(),
                ),
              );

              if (eventToDelete == null) return; // 사용자가 취소를 누른 경우

              // 선택된 이벤트를 events 맵에서 삭제합니다.
              events[selectedDay]!.remove(eventToDelete);
              if (events[selectedDay]!.isEmpty) events.remove(selectedDay);

              // 화면을 갱신합니다.
              setState(() {});
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),

    );
  }


}
