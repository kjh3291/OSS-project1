import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDo {
  final String id;
  final String todoText;
  final DateTime date;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    required this.date,
    this.isDone = false,
  });
}

class OtherScreen extends StatefulWidget {
  OtherScreen({Key? key}) : super(key: key);

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  List<ToDo> _todayToDo = [];
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _loadToDos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadToDos();
  }

  void _loadToDos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todayToDo = _loadToDoList(prefs, 'today');
    });
  }

  Future<void> _refresh() async {
    _loadToDos();
  }

  List<ToDo> _loadToDoList(SharedPreferences prefs, String key) {
    List<String>? todoList = prefs.getStringList(key);
    if (todoList != null) {
      return todoList.map((todo) {
        List<String> todoData = todo.split('|');
        DateTime date = DateTime(
          DateTime.now().year,
          int.parse(todoData[2]),
          int.parse(todoData[3]),
        );
        return ToDo(
          id: todoData[0],
          todoText: todoData[1],
          date: date,
          isDone: todoData[4] == 'true',
        );
      }).toList();
    } else {
      return [];
    }
  }

  void _saveToDos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _saveToDoList(prefs, 'today', _todayToDo);
  }

  void _saveToDoList(SharedPreferences prefs, String key, List<ToDo> todoList) {
    List<String> encodedList = todoList.map((todo) {
      return '${todo.id}|${todo.todoText}|${todo.date.month}|${todo.date.day}|${todo.isDone}';
    }).toList();
    prefs.setStringList(key, encodedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PageView.builder(
          controller: _pageController,
          itemCount: (_todayToDo.length / 3).ceil(),
          itemBuilder: (context, pageIndex) {
            final startIndex = pageIndex * 3;
            final endIndex = startIndex + 3;
            final pageItems = _todayToDo.sublist(startIndex, endIndex > _todayToDo.length ? _todayToDo.length : endIndex);

            return GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  if (_pageController.page != 0) {
                    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }
                } else if (details.primaryVelocity! < 0) {
                  if (_pageController.page != (_todayToDo.length / 3).ceil() - 1) {
                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  }
                }
              },
              child: ListView.builder(
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  final item = pageItems[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        item.todoText,
                        style: item.isDone
                            ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                        )
                            : null,
                      ),
                      trailing: Checkbox(
                        value: item.isDone,
                        onChanged: (value) {
                          setState(() {
                            item.isDone = value!;
                            _saveToDos();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('너 시발 재능 있어'),),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtherScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
