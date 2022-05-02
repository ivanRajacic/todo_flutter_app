import 'package:flutter/material.dart';
import 'add_todo_page.dart';
import 'todo_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoCardData> todoCardListInformation = [];
  List<TodoCardWidget> todoCardList = [];
  int cardCounter = 0;
  int completedCardCounter = 0;

  @override
  Widget build(BuildContext context) {
    void updateCompletedCardCounter(bool isChanged) {
      setState(() {
        if (isChanged) {
          completedCardCounter++;
        } else {
          completedCardCounter--;
        }
      });
    }

    void deleteCard(Key key) {
      setState(() {
        for (var i = 0; i < todoCardList.length; i++) {
          if (todoCardList[i].key == key) {
            todoCardList.remove(todoCardList[i]);
            cardCounter = todoCardList.length;
          }
        }
      });
    }

    void addCard() async {
      final result = await Navigator.pushNamed(context, '/add');
      if (result != null) {
        final TodoCardData data = result as TodoCardData;
        setState(() {
          todoCardList.add(TodoCardWidget(
            title: data.title,
            date: data.date,
            priority: data.priority,
            callback: updateCompletedCardCounter,
            deleteCallback: deleteCard,
            key: UniqueKey(),
          ));
          // todoCardListInformation.add(data);
          cardCounter = todoCardList.length;
        });
      }
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
                child: todoCardList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: todoCardList.length,
                        itemBuilder: (context, index) {
                          return todoCardList[index];
                        },
                      )
                    : const Text('No todo\'s')),
          ]),
        ),
      ),
    );
  }
}
