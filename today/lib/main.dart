import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

List week = ['일', '월', '화', '수', '목', '금', '토'];
var kColumnLength = 32;
double kFirstColumnHeight = 20;
double kBoxSize = 60;

Expanded buildTimeColumn() {
  return Expanded(
    child: Column(
      children: [
        SizedBox(
          height: kFirstColumnHeight,
        ),
        ...List.generate(
          kColumnLength,
              (index) {
            if (index % 2 == 0) {
              return const Divider(
                color: Colors.grey,
                height: 0,
              );
            }
            return SizedBox(
              height: kBoxSize,
              child: Center(child: Text('${index ~/ 2 + 9}')),
            );
          },
        ),
      ],
    ),
  );
}

List<Widget> buildDayColumn0(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.purple,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> buildDayColumn1(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight,
            left: 0,
            right: 0,
            height: kBoxSize * 3,
            child: Container(
              color: Colors.redAccent,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 3,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.yellow,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 7,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.lightGreenAccent,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 9.5,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.blueGrey,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> buildDayColumn2(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight + kBoxSize,
            left: 0,
            right: 0,
            height: kBoxSize * 3,
            child: Container(
              color: Colors.blueAccent,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize,
            left: 0,
            right: 0,
            height: kBoxSize * 3,
            child: Container(
              color: Colors.yellowAccent,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize,
            left: 0,
            right: 0,
            height: kBoxSize * 3,
            child: Container(
              color: Colors.yellow,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> buildDayColumn3(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight + kBoxSize,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.green,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 5,
            left: 0,
            right: 0,
            height: kBoxSize * 4,
            child: Container(
              color: Colors.deepPurpleAccent,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 9,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.greenAccent,
            ),
          ),

          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> buildDayColumn4(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight + kBoxSize,
            left: 0,
            right: 0,
            height: kBoxSize * 3,
            child: Container(
              color: Colors.pinkAccent,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 6,
            left: 0,
            right: 0,
            height: kBoxSize * 3,
            child: Container(
              color: Colors.pink,
            ),
          ),

          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> buildDayColumn5(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight + kBoxSize * 4,
            left: 0,
            right: 0,
            height: kBoxSize * 4,
            child: Container(
              color: Colors.blue,
            ),
          ),

          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

List<Widget> buildDayColumn6(int index) {
  return [
    const VerticalDivider(
      color: Colors.grey,
      width: 0,
    ),
    Expanded(
      flex: 4,
      child: Stack(
        children: [
          Positioned(
            top: kFirstColumnHeight,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.purple,
            ),
          ),
          Positioned(
            top: kFirstColumnHeight,
            left: 0,
            right: 0,
            height: kBoxSize * 2,
            child: Container(
              color: Colors.deepPurple,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20,
                child: Text(
                  '${week[index]}',
                ),
              ),
              ...List.generate(
                kColumnLength,
                    (index) {
                  if (index % 2 == 0) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    );
                  }
                  return SizedBox(
                    height: kBoxSize,
                    child: Container(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: (){
                print("menu button is clicked");
              },
            ),
            title: Text("Weekly Routine"),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.all(10),
              height: kColumnLength / 2 * kBoxSize + kColumnLength,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  buildTimeColumn(),
                  ...buildDayColumn0(0),
                  ...buildDayColumn1(1),
                  ...buildDayColumn2(2),
                  ...buildDayColumn3(3),
                  ...buildDayColumn4(4),
                  ...buildDayColumn5(5),
                  ...buildDayColumn6(6),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(),
        )
    );
  }
}