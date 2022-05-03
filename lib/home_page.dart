import 'dart:collection';

import 'package:flutter/material.dart';
import 'add_todo_page.dart';
import 'todo_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HashMap allTodoCardMap = HashMap<TodoCardWidget, bool>();
  List<TodoCardWidget> workingTodoCardList = [];
  String filterStatus = 'All';

  int cardCounter = 0;
  int completedCardCounter = 0;

  bool getCardCheckStatus(Key key) {
    bool returnValue = false;
    allTodoCardMap.forEach((k, v) {
      if (k.key == key) {
        returnValue = v;
        // return v;
      }
    });

    return returnValue;
  }

  void updateCompletedCardCounter(Key key, bool isChecked) {
    setState(() {
      if (isChecked) {
        completedCardCounter++;
        TodoCardWidget temp =
            allTodoCardMap.keys.firstWhere((element) => element.key == key);
        allTodoCardMap.update(temp, (value) => true);
      } else {
        completedCardCounter--;
        TodoCardWidget temp =
            allTodoCardMap.keys.firstWhere((element) => element.key == key);
        allTodoCardMap.update(temp, (value) => false);
      }
      workingTodoCardList =
          allTodoCardMap.keys.toList() as List<TodoCardWidget>;
    });
  }

  void filterTodoCards(bool shouldFilterCards, bool filterCondition) {
    workingTodoCardList.clear();
    if (shouldFilterCards == true) {
      setState(() {
        if (filterCondition) {
          filterStatus = 'Completed';
        } else {
          filterStatus = 'Active';
        }
        workingTodoCardList = (Map.from(allTodoCardMap)
              ..removeWhere((k, v) => v != filterCondition))
            .keys
            .toList()
            .cast<TodoCardWidget>();
      });
    } else {
      setState(() {
        filterStatus = 'All';
        workingTodoCardList =
            allTodoCardMap.keys.toList() as List<TodoCardWidget>;
      });
    }
  }

  void deleteCard(Key key, bool isChecked) {
    List<TodoCardWidget> tempTodoCardList =
        allTodoCardMap.keys.toList() as List<TodoCardWidget>;
    for (var i = 0; i < tempTodoCardList.length; i++) {
      if (tempTodoCardList[i].key == key) {
        setState(() {
          if (isChecked) {
            completedCardCounter--;
          }
          allTodoCardMap.remove(tempTodoCardList[i]);
          cardCounter = allTodoCardMap.length;
          workingTodoCardList =
              allTodoCardMap.keys.toList() as List<TodoCardWidget>;
        });
      }
    }
  }

  void addCard() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null) {
      final TodoCardData data = result as TodoCardData;
      setState(() {
        allTodoCardMap.putIfAbsent(
            TodoCardWidget(
              title: data.title,
              date: data.date,
              priority: data.priority,
              callback: updateCompletedCardCounter,
              deleteCallback: deleteCard,
              checkStatusCallback: getCardCheckStatus,
              key: UniqueKey(),
            ),
            () => false);
        cardCounter = allTodoCardMap.length;
        workingTodoCardList =
            allTodoCardMap.keys.toList() as List<TodoCardWidget>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$completedCardCounter' ' of ' '$cardCounter',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () => filterTodoCards(false, false),
                                child: Text(
                                  'All',
                                  style: TextStyle(
                                      color: filterStatus == 'All'
                                          ? Colors.red
                                          : Colors.black),
                                )),
                            TextButton(
                                onPressed: () => filterTodoCards(true, false),
                                child: Text(
                                  'Active',
                                  style: TextStyle(
                                      color: filterStatus == 'Active'
                                          ? Colors.red
                                          : Colors.black),
                                )),
                            TextButton(
                                onPressed: () => filterTodoCards(true, true),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                      color: filterStatus == 'Completed'
                                          ? Colors.red
                                          : Colors.black),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: workingTodoCardList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: workingTodoCardList.length,
                        itemBuilder: (context, index) {
                          // List<TodoCardWidget> tempTodoCardList =
                          //     allTodoCardMap.keys.toList()
                          //         as List<TodoCardWidget>;
                          return workingTodoCardList[index];
                        },
                      )
                    : const Text('No todo\'s')),
          ]),
        ),
      ),
    );
  }
}
