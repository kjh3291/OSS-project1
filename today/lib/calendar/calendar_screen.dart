import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/main.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime selectedDay = DateTime.now();
  late Map<DateTime, List<dynamic>> events;
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedEventDay = DateTime.now();
  TextEditingController eventController = TextEditingController();
  TextEditingController editEventController = TextEditingController();
  bool isAddingEvent = false;
  String? selectedEvent;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    events = {
      DateTime(selectedDay.year, selectedDay.month, selectedDay.day): ['Event A'],
    };
    loadEventsFromLocalStorage();
  }

  Future<void> loadEventsFromLocalStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? eventsJson = prefs.getString('events');

      if (eventsJson != null) {
        final Map<String, dynamic> decodedJson = jsonDecode(eventsJson);
        setState(() {
          events = decodedJson.map((key, value) {
            final DateTime date = DateTime.parse(key);
            final List<dynamic> eventDescriptions = value.cast<String>();
            return MapEntry(date, eventDescriptions);
          });
        });
      }
    } catch (e) {
      print('Failed to load events from local storage: $e');
    }
  }

  Future<void> saveEventsToLocalStorage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String eventsJson = jsonEncode(events.map((key, value) {
        final String dateKey = key.toIso8601String();
        final List<String> eventDescriptions = value.cast<String>();
        return MapEntry(dateKey, eventDescriptions);
      }));
      await prefs.setString('events', eventsJson);
    } catch (e) {
      print('Failed to save events to local storage: $e');
    }
  }

  void addEvent() {
    final eventText = eventController.text.trim();

    if (eventText.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('경고'),
            content: Text('일정을 입력해주세요.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  MyHomePage();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      if (events[selectedEventDay] != null) {
        events[selectedEventDay]!.add(eventText);
      } else {
        events[selectedEventDay] = [eventText];
      }
      eventController.clear();
      isAddingEvent = false;
      saveEventsToLocalStorage();
    });
  }

  void showAddEventPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isAddingEvent = false;
            });
            eventController.clear();
            Navigator.pop(context);
          },
          child: AlertDialog(
            title: Text('일정 추가'),
            content: TextField(
              controller: eventController,
              decoration: InputDecoration(
                hintText: '일정을 입력해주세요...',
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  addEvent();
                  Navigator.pop(context);
                },
                child: Text('일정 추가'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isAddingEvent = false;
                  });
                  eventController.clear();
                  Navigator.pop(context);
                },
                child: Text('취소'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showEditEventPopup(String event) {
    editEventController.text = event;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일정 수정'),
          content: TextField(
            controller: editEventController,
            decoration: InputDecoration(
              hintText: '일정을 수정해주세요...',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                editEvent(event);
                Navigator.pop(context);
              },
              child: Text('일정 수정'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void editEvent(String oldEvent) {
    final editedEventText = editEventController.text.trim();
    if (oldEvent != editedEventText && editedEventText.isNotEmpty) {
      setState(() {
        final List<dynamic>? eventList = events[selectedDay];
        if (eventList != null) {
          final int eventIndex = eventList.indexOf(oldEvent);
          if (eventIndex != -1) {
            eventList[eventIndex] = editedEventText;
          }
        }
        saveEventsToLocalStorage();
      });
    }
  }

  void deleteEvent(String event) {
    setState(() {
      events[selectedDay]!.remove(event);
      saveEventsToLocalStorage();
    });
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

  Color getSelectedDayCircleColor(DateTime day) {
    if (isSameDay(day, selectedDay)) {
      return getAppBarBackgroundColor();
    } else {
      return Colors.transparent;
    }
  }

  BoxDecoration selectedDecorationBuilder(DateTime date, DateTime focusedDay) {
    if (isSameDay(date, selectedDay)) {
      return BoxDecoration(
        shape: BoxShape.circle,
        color: getAppBarBackgroundColor(),
      );
    } else {
      return BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      );
    }
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: getAppBarBackgroundColor(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2010),
                    lastDay: DateTime(2030),
                    calendarFormat: calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        this.selectedDay = selectedDay;
                        this.focusedDay = focusedDay;
                        selectedEventDay = selectedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        calendarFormat = format;
                      });
                    },
                    eventLoader: (day) {
                      return events[day] ?? [];
                    },
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events[selectedDay]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final event = events[selectedDay]![index];
                      return Dismissible(
                        key: Key(event),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          deleteEvent(event);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.0),
                          color: Colors.redAccent,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(event),
                          onTap: () {
                            showEditEventPopup(event);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isAddingEvent = !isAddingEvent;
          });
          if (isAddingEvent) {
            showAddEventPopup();
          }
        },
        child: Icon(isAddingEvent ? Icons.close : Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalendarScreen(),
  ));
}