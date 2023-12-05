import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDo {
  final String id;
  final String todoText;
  final DateTime date; // 날짜 속성 추가
  bool isDone;

  ToDo({required this.id, required this.todoText, required this.date, this.isDone = false});

  static List<ToDo> todoList() {
    return [];
  }
}

class ToDoList extends StatelessWidget {
  ToDoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: getAppBarBackgroundColor(),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.calendar_today), text: '오늘 하루'),
              Tab(icon: Icon(Icons.calendar_view_day), text: '내일 하루'),
            ],
          ),
          title: Text('하루의 일들'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            ToDoListTabContent(todoList: _todayToDo, addToDo: _addTodayToDoItem),
            ToDoListTabContent(todoList: _tomorrowToDo, addToDo: _addTomorrowToDoItem),
          ],
        ),
      ),
    );
  }
}

class ToDoListTabContent extends StatefulWidget {
  final List<ToDo> todoList;
  final Function(String) addToDo;

  ToDoListTabContent({required this.todoList, required this.addToDo});

  @override
  State<ToDoListTabContent> createState() => _ToDoListTabContentState();
}

class _ToDoListTabContentState extends State<ToDoListTabContent> {
  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: widget.todoList.length,
            itemBuilder: (context, index) {
              final item = widget.todoList[index];
              return Dismissible(
                key: Key(item.id),
                onDismissed: (direction) {
                  setState(() {
                    widget.todoList.removeAt(index);
                  });
                  _saveToDos(); // 삭제 후에 저장
                },
                background: Container(
                  color: Colors.red,
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 15, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.isDone,
                      onChanged: (bool? value) {
                        setState(() {
                          item.isDone = value!;
                        });
                        _saveToDos(); // 체크 상태 변경 후에 저장
                      },
                    ),
                    title: Text(
                      '${item.todoText}',
                      style: item.isDone
                          ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                      )
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      labelText: '하루의 시작',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  String todo = _todoController.text.trim();
                  if (todo.isNotEmpty) {
                    _todoController.clear();
                    widget.addToDo(todo);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('경고'),
                          content: Text('내용을 입력하세요.'),
                          actions: [
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MyApp());
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
      appBar: AppBar(),
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
                  MaterialPageRoute(builder: (context) => ToDoList()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
