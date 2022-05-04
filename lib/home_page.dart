import 'dart:collection';

import 'package:flutter/material.dart';
import 'todo.dart';
import 'todo_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HashMap allTodoCard = HashMap<TodoCardWidget, bool>();
  List<TodoCardWidget> workingTodoCard = [];
  String filterStatus = 'All';

  int cardCounter = 0;
  int completedCardCounter = 0;

  bool getCardStatus(Key key) {
    bool returnValue = false;
    allTodoCard.forEach((k, v) {
      if (k.key == key) {
        returnValue = v;
      }
    });

    return returnValue;
  }

  void updateCardStatus(Key key, bool isChecked) {
    setState(() {
      if (isChecked) {
        completedCardCounter++;
        allTodoCard.forEach((k, v) {
          if (k.key == key) {
            allTodoCard.update(k, (value) => true);
          }
        });
      } else {
        completedCardCounter--;
        allTodoCard.forEach((k, v) {
          if (k.key == key) {
            allTodoCard.update(k, (value) => false);
          }
        });
      }
      if (filterStatus == 'All') {
        workingTodoCard = allTodoCard.keys.toList() as List<TodoCardWidget>;
      } else if (filterStatus == 'Active') {
        filterCards(true, false);
      } else {
        filterCards(true, true);
      }
    });
  }

  void filterCards(bool shouldFilterCards, bool showCompleted) {
    workingTodoCard.clear();
    if (shouldFilterCards == true) {
      if (showCompleted) {
        filterStatus = 'Completed';
      } else {
        filterStatus = 'Active';
      }
      setState(() {
        workingTodoCard = (Map.from(allTodoCard)
              ..removeWhere((k, v) => v != showCompleted))
            .keys
            .toList()
            .cast<TodoCardWidget>();
      });
    } else {
      setState(() {
        filterStatus = 'All';
        workingTodoCard = allTodoCard.keys.toList() as List<TodoCardWidget>;
      });
    }
  }

  void deleteCard(Key key, bool isChecked) {
    List<TodoCardWidget> tempTodoCardList =
        allTodoCard.keys.toList() as List<TodoCardWidget>;
    for (var i = 0; i < tempTodoCardList.length; i++) {
      if (tempTodoCardList[i].key == key) {
        setState(() {
          if (isChecked) {
            completedCardCounter--;
          }
          allTodoCard.remove(tempTodoCardList[i]);
          cardCounter = allTodoCard.length;
          workingTodoCard = allTodoCard.keys.toList() as List<TodoCardWidget>;
        });
      }
    }
  }

  void addCard() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null) {
      final Todo data = result as Todo;
      setState(() {
        allTodoCard.putIfAbsent(
            TodoCardWidget(
              title: data.title,
              date: data.date,
              priority: data.priority,
              callback: updateCardStatus,
              deleteCallback: deleteCard,
              checkStatusCallback: getCardStatus,
              key: UniqueKey(),
            ),
            () => false);
        cardCounter = allTodoCard.length;
        workingTodoCard = allTodoCard.keys.toList() as List<TodoCardWidget>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //glavni container
      floatingActionButton: FloatingActionButton(
        onPressed: addCard,
        tooltip: 'Add Card',
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: Padding(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedCardCounter' ' of ' '$cardCounter',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => filterCards(false, false),
                              child: Text(
                                'All',
                                style: TextStyle(
                                  color: filterStatus == 'All'
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => filterCards(true, false),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  color: filterStatus == 'Active'
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => filterCards(true, true),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  color: filterStatus == 'Completed'
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: workingTodoCard.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: workingTodoCard.length,
                        itemBuilder: (context, index) {
                          return workingTodoCard[index];
                        },
                      )
                    : const Text('No todo\'s')),
          ]),
        ),
      ),
    );
  }
}
