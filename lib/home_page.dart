import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'add_todo_page.dart';
import 'todo_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<InfromationData> todoCardListInformation = [];
  int cardCounter = 0;
  int completedCardCounter = 0;

  @override
  Widget build(BuildContext context) {
    //implementirat kartice
    void addCard() async {
      final result = await Navigator.pushNamed(context, '/add');
      if (result != null) {
        InfromationData data = result as InfromationData;
        setState(() {
          todoCardListInformation.add(data);
          cardCounter = todoCardListInformation.length;
        });
      }
    }

    void updateCompletedCardCounter(bool isChanged) {
      setState(() {
        if (isChanged) {
          completedCardCounter++;
        } else {
          completedCardCounter--;
        }
      });
    }

    return Scaffold(
      //glavni container
      floatingActionButton: FloatingActionButton(
        onPressed: () => addCard(),
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'My Tasks',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '$completedCardCounter' ' of ' '$cardCounter',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: todoCardListInformation.length,
                itemBuilder: (context, index) {
                  final InfromationData item = todoCardListInformation[index];
                  return TodoCardWidget(
                    title: item.title,
                    date: item.date,
                    priority: item.priority,
                    callback: updateCompletedCardCounter,
                  );
                },
              ),
            ),
            // const TodoCardWidget(
            //   title: 'test',
            //   date: 'test',
            //   priority: 'test',
            // )
          ]),
        ),
      ),
    );
  }
}
