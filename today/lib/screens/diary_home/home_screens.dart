import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/screens/diary_home/widgets/item_note.dart';

import '../note/add_note.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<ItemNote> itemNotes = [];

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
  void initState() {
    super.initState();
    loadItemNotes();
  }

  Future<void> loadItemNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final itemNotesJson = prefs.getString('itemNotes');

    if (itemNotesJson != null) {
      final List<dynamic> decodedJson = jsonDecode(itemNotesJson);
      setState(() {
        itemNotes = decodedJson.map((json) => ItemNote.fromJson(json)).toList();
      });
    }
  }

  Future<void> saveItemNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final itemNotesJson = jsonEncode(itemNotes.map((itemNote) => itemNote.toJson()).toList());
    await prefs.setString('itemNotes', itemNotesJson);
  }

  Future<void> editItemNote(ItemNote itemNote) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddNote(initialItemNote: itemNote)),
    );
    if (result != null && result is ItemNote) {
      setState(() {
        final index = itemNotes.indexWhere((note) => note.title == itemNote.title && note.content == itemNote.content);
        if (index != -1) {
          itemNotes[index] = result;
        }
      });
      await saveItemNotes();
    }
  }

  Future<void> deleteItemNote(ItemNote itemNote) async {
    setState(() {
      itemNotes.remove(itemNote);
    });
    await saveItemNotes();
  }

  @override
  Widget build(BuildContext context) {
    itemNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate)); // selectedDate를 기준으로 내림차순 정렬

    return Scaffold(
      appBar: AppBar(
        title: const Text('다른 하루들', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: getAppBarBackgroundColor(),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: itemNotes.length,
        itemBuilder: (context, index) {
          final itemNote = itemNotes[index];
          return InkWell(
            onTap: () => editItemNote(itemNote),
            child: Dismissible(
              key: ValueKey(itemNote), // UniqueKey 대신 ValueKey를 사용
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              onDismissed: (direction) => deleteItemNote(itemNote),
              child: ItemNote(
                key: ValueKey(itemNote), // UniqueKey 대신 ValueKey를 사용
                title: itemNote.title,
                content: itemNote.content,
                selectedDate: itemNote.selectedDate, // ItemNote의 selectedDate를 그대로 전달
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNote()),
          );
          if (result != null && result is ItemNote) {
            setState(() {
              itemNotes.add(result);
            });
            await saveItemNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
