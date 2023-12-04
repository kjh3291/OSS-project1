void _saveToDoList(SharedPreferences prefs, String key, List<ToDo> todoList) {
  List<String> encodedList = todoList.map((todo) {
    return '${todo.id}|${todo.todoText}|${todo.date.month}|${todo.date.day}|${todo.isDone}'; // 월과 일만 저장
  }).toList();
  prefs.setStringList(key, encodedList);
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

@override
Widget build(BuildContext context) {
  final controller = DefaultTabController(
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
          _buildTabContent(_todayToDo, _addTodayToDoItem),
          _buildTabContent(_tomorrowToDo, _addTomorrowToDoItem),
        ],
      ),
    ),
  );
  return controller;
}

Widget _buildTabContent(List<ToDo> todoList, Function(String) addToDo) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final item = todoList[index];
            return Dismissible(
              key: Key(item.id),
              onDismissed: (direction) {
                setState(() {
                  todoList.removeAt(index);
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
                  addToDo(todo);
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

 void _addTodayToDoItem(String toDo) {
   if (toDo.isNotEmpty) {
     setState(() {
       DateTime now = DateTime.now();
       _todayToDo.add(
         ToDo(
           id: now.millisecondsSinceEpoch.toString(),
           todoText: toDo,
           date: DateTime(now.year, now.month, now.day), // 월과 일만 저장
         ),
       );
       _saveToDos(); // 추가 후에 저장
     });
   }
 }

 void _addTomorrowToDoItem(String toDo) {
   if (toDo.isNotEmpty) {
     setState(() {
       DateTime now = DateTime.now();
       _tomorrowToDo.add(
         ToDo(
           id: now.millisecondsSinceEpoch.toString(),
           todoText: toDo,
           date: DateTime(now.year, now.month, now.day + 1), // 월과 일만 저장
         ),
       );
       _saveToDos(); // 추가 후에 저장
     });
   }
 }
