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
            Dismissible(
              key: UniqueKey(),
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
              child: InkWell(
                onTap: () => editItemNote(itemNote),
                child: ItemNote(
                  title: itemNote.title,
                  content: itemNote.content,
                ),
              ),
            ),
          ],
        ],
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
