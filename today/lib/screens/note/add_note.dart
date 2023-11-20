import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../diary_home/widgets/item_note.dart';

class AddNote extends StatefulWidget {
  final ItemNote? initialItemNote;

  const AddNote({Key? key, this.initialItemNote}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialItemNote?.title ?? '');
    _contentController = TextEditingController(text: widget.initialItemNote?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '오늘 하루',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: '제목',
              labelText: '제목',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              prefixIcon: Icon(Icons.title),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _selectDate,
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Text(
                  DateFormat('yyyy년 MM월 dd일').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _contentController,
            maxLines: 30,
            decoration: const InputDecoration(
              hintText: '작성해주세요....',
              labelText: '작성해주세요....',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String content = _contentController.text;

                if (title.isEmpty && content.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('알림'),
                        content: const Text('제목과 내용을 작성하지 않았습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (title.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('알림'),
                        content: const Text('제목을 작성하지 않았습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (content.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('알림'),
                        content: const Text('내용을 작성하지 않았습니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ItemNote itemNote = ItemNote(
                    title: title,
                    content: content,
                    selectedDate: _selectedDate,
                  );

                  Navigator.pop(context, itemNote);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('저장하기'),
            ),
          ],
        ),
      ),
    );
  }
}
