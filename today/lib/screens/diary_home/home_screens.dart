import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:today/screens/diary_home/widgets/item_note.dart';

import '../note/add_note.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<ItemNote> itemNotes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('다른 하루들', style: TextStyle(color: Colors.blue)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          for (ItemNote itemNote in itemNotes) ...[
            ItemNote(
              title: itemNote.title,
              content: itemNote.content,
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNode()),
          );
          if (result != null && result is ItemNote) {
            setState(() {
              itemNotes.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
