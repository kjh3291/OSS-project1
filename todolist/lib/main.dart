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