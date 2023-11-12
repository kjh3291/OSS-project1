import 'package:flutter/material.dart';
import 'package:today/screens/diary_home/widgets/item_note.dart';


class DiaryScreen extends StatelessWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다른 하루들',style: TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: const [
          ItemNote(color: Colors.green),
          ItemNote(color: Colors.red),
          ItemNote(color: Colors.blue),
          ItemNote(color: Colors.orange),
          ItemNote(color: Colors.indigo),
          ItemNote(color: Colors.deepOrange),
          ItemNote(color: Colors.purple),
        ],
      ),

    );
  }
}
