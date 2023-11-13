import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../diary_home/widgets/item_note.dart';

class AddNote extends StatefulWidget {
  final ItemNote? initialItemNote; // 수정된 부분

  const AddNote({Key? key, this.initialItemNote}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

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

                ItemNote itemNote = ItemNote(
                  title: title,
                  content: content,
                );

                Navigator.pop(context, itemNote);
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
