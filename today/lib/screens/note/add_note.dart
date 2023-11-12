import 'package:flutter/material.dart';



class AddNode extends StatelessWidget {
  const AddNode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘 하루',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextField(
            decoration:  InputDecoration(
              hintText: '제목',
              labelText: '제목',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              prefixIcon: const Icon(Icons.title)
            ),
          ),
        const SizedBox(height: 20),
          TextField(
            maxLines: 30,
            decoration: InputDecoration(
              hintText: '작성해주세요....',
              labelText: '작성해주세요....',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        width: double. infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: ElevatedButton(
          onPressed: (){},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          child: const Text('저장하기'),
        ),
      ),
    );
  }
}
