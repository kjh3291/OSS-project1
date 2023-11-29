import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:table_calendar/table_calendar.dart';

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
  bool isAddingEvent = false;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    events = {
      DateTime(selectedDay.year, selectedDay.month, selectedDay.day): ['Event A'],
    };
    loadEventsFromLocalStorage();
  }

  void loadEventsFromLocalStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/events.txt');

      if (await file.exists()) {
        final lines = await file.readAsLines();
        setState(() {
          events = lines.fold<Map<DateTime, List<dynamic>>>({}, (map, line) {
            final parts = line.split('|');
            if (parts.length == 2) {
              final eventDate = DateTime.parse(parts[0]);
              final eventDescription = parts[1];
              final date = DateTime(eventDate.year, eventDate.month, eventDate.day);
              if (map[date] != null) {
                map[date]!.add(eventDescription);
              } else {
                map[date] = [eventDescription];
              }
            }
            return map;
          });
        });
      }
    } catch (e) {
      print('Failed to load events from local storage: $e');
    }
  }

  void saveEventsToLocalStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/events.txt');

    final lines = events.entries.map((entry) {
      final date = entry.key;
      final descriptions = entry.value;
      return descriptions
          .map((description) => '${date.toIso8601String()}|$description')
          .join('      ');
    }).join('    ');

    await file.writeAsString(lines);
  }

  void addEvent() {
    setState(() {
      if (events[selectedEventDay] != null) {
        events[selectedEventDay]!.add(eventController.text);
      } else {
        events[selectedEventDay] = [eventController.text];
      }
      eventController.clear();
      isAddingEvent = false;
      saveEventsToLocalStorage();
    });
  }

  void showAddEventPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isAddingEvent = false;
            });
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

  void showEventDetails(String event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Details'),
          content: Text(event),
          actions: [
            ElevatedButton(
              onPressed: () {
                editEvent(event);
                Navigator.pop(context);
              },
              child: Text('일정 수정'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteEvent(event);
                Navigator.pop(context);
              },
              child: Text('일정 삭제'),
            ),
          ],
        );
      },
    );
  }

  void editEvent(String event) {
    eventController.text = event;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('일정 수정'),
          content: TextField(
            controller: eventController,
            decoration: InputDecoration(
              hintText: '일정을 입력하세요...',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updateEvent(event);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteEvent(String event) {
    setState(() {
      events[selectedEventDay]!.remove(event);
      saveEventsToLocalStorage();
    });
  }

  void updateEvent(String oldEvent) {
    final updatedEvent = eventController.text;
    setState(() {
      events[selectedEventDay]!.remove(oldEvent);
      events[selectedEventDay]!.add(updatedEvent);
      eventController.clear();
      saveEventsToLocalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
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
                      return ListTile(
                        title: Text(event),
                        onTap: () {
                          showEventDetails(event);
                        },
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
