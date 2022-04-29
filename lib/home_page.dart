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

  @override
  Widget build(BuildContext context) {
    //implementirat kartice
    void addCard() async {
      final result =
          await Navigator.pushNamed(context, '/add') as InfromationData;
      setState(() {
        todoCardListInformation.add(result);
      });
    }

    return Scaffold(
      //glavni container
      floatingActionButton: FloatingActionButton(
        onPressed: () => addCard(),
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                Text('My Tasks'),
                Text('Counter'),
              ],
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
                  );
                },
              ),
            ),
            const Text('notest')
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
