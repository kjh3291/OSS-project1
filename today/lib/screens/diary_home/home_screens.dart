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
  List<ItemNote> filteredNotes = []; // 검색 결과를 저장하는 리스트 변수
  TextEditingController searchController = TextEditingController(); // 검색어를 입력받는 컨트롤러

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
        filteredNotes = List.from(itemNotes); // 초기에는 전체 일기를 보여줍니다.
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
        filteredNotes = List.from(itemNotes); // 일기가 수정되면 검색 결과도 업데이트합니다.
      });
      await saveItemNotes();
    }
  }

  Future<void> deleteItemNote(ItemNote itemNote) async {
    setState(() {
      itemNotes.remove(itemNote);
      filteredNotes.remove(itemNote); // 일기가 삭제되면 검색 결과에서도 제거합니다.
    });
    await saveItemNotes();
  }

  void searchNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        // 검색어가 없을 경우 전체 일기를 보여줍니다.
        filteredNotes = List.from(itemNotes);
      } else {
        // 검색어가 있는 경우 해당 검색어와 관련된 일기를 필터링합니다.
        filteredNotes = itemNotes.where((note) =>
        note.title.contains(query) || note.content.contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    itemNotes.sort((a, b) => b.selectedDate.compareTo(a.selectedDate)); // selectedDate를 기준으로 내림차순 정렬

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: '검색',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: searchNotes, // 검색어가 변경될 때마다 검색 기능을 호출합니다.
        ),
        centerTitle: true,
        backgroundColor: getAppBarBackgroundColor(),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: filteredNotes.length, // 검색 결과의 개수만큼 아이템을 표시합니다.
        itemBuilder: (context, index) {
          final itemNote = filteredNotes[index];
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
              filteredNotes = List.from(itemNotes); // 일기가 추가되면 검색 결과에도 반영합니다.
            });
            await saveItemNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
