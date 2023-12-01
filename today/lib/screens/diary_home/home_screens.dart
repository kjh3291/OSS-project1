import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<ItemNote> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

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
        filteredNotes = List.from(itemNotes);
        // 날짜 순으로 정렬
        filteredNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate));
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
        final index = itemNotes.indexWhere(
                (note) => note.title == itemNote.title && note.content == itemNote.content);
        if (index != -1) {
          itemNotes[index] = result;
        }
        filteredNotes = List.from(itemNotes);
        // 날짜 순으로 정렬
        filteredNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate));
      });
      await saveItemNotes();
    }
  }

  Future<void> deleteItemNote(ItemNote itemNote) async {
    setState(() {
      itemNotes.remove(itemNote);
      filteredNotes.remove(itemNote);
    });
    await saveItemNotes();
  }

  void searchNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNotes = List.from(itemNotes);
        // 날짜 순으로 정렬
        filteredNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate));
      } else {
        filteredNotes = itemNotes.where((note) {
          DateTime noteDate = note.selectedDate;
          String formattedNoteDate =
          DateFormat('yyyy년 MM월 dd일 EEEE', 'ko_KR').format(noteDate);
          return note.title.contains(query) ||
              note.content.contains(query) ||
              formattedNoteDate.contains(query) ||
              formattedNoteDate.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    itemNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: '검색',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'KCC-Ganpan', // 'KCC-Ganpan' 폰트 적용
          ),
          onChanged: searchNotes,
        ),
        centerTitle: true,
        backgroundColor: getAppBarBackgroundColor(),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final itemNote = filteredNotes[index];
          return InkWell(
            onTap: () => editItemNote(itemNote),
            child: Dismissible(
              key: ValueKey(itemNote),
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
                key: ValueKey(itemNote),
                title: itemNote.title,
                content: itemNote.content,
                selectedDate: itemNote.selectedDate,
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
              filteredNotes = List.from(itemNotes);
              // 날짜 순으로 정렬
              filteredNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate));
            });
            await saveItemNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
