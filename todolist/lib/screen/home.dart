import 'package:flutter/material.dart';
import 'package:todolist/colors/color.dart';
import 'package:todolist/widget/todo_item.dart';
import 'package:todolist/model/todo.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key : key);

  final todoList = ToDo.todoList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,
                vertical: 15
            ),
            child: Column(
              children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 50,
                              bottom: 20,
                          ),
                          child: Text(
                            'Today',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w500,
                          ),
                         ),
                        ),
                        for ( ToDo todo in todoList )
                        ToDoItem(todo: todo,),
                      ],
                    ),
                  ),
              ],
            ),
          ),
Align(
    alignment: Alignment.bottomCenter,
    child: Row(children: [
      Expanded(
         child: Container(
           margin: EdgeInsets.only(
              bottom: 20,
              right: 20,
              left: 20,
           ),
           padding: EdgeInsets.symmetric(
               horizontal: 20,
               vertical: 5,
           ),
           decoration: BoxDecoration(
             color: Colors.white,
             boxShadow: const [
               BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.0),
                blurRadius: 10.0,
                spreadRadius: 0.0,
             ),],
               borderRadius: BorderRadius.circular(10),
           ),
           child: TextField(
             decoration: InputDecoration(
               hintText: 'Add a new todo item',
               border: InputBorder.none,
             ),
           ),
         ),
       ),
      Container(
        margin: EdgeInsets.only(
          bottom: 20,
          right: 20,
        ),
        child: ElevatedButton(
          child: Text('+', style: TextStyle(fontSize: 40,),),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: tdBlue,
            minimumSize: Size(60, 60),
            elevation: 10,
          ),
        ),
      )
      ]),
     )
    ],
   ),
  );
 }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBlue,
      title: Text(
          'To-Do-List',
          style: TextStyle(fontSize: 40.0,
          color: tdBlack),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
