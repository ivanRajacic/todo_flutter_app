import 'package:flutter/material.dart';
import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //implementirat kartice
    // List<Cards> cardList = [];
    InfromationData result;
    void addCard() async {
      result = await Navigator.pushNamed(context, '/add') as InfromationData;
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
            // Container(
            //   child: Flexible(
            //     child: ListView.builder(
            //       scrollDirection: Axis.vertical,
            //       itemCount: _cardlist.length,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           child: Text(_cardlist[index]),
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ]),
        ),
      ),
    );
  }
}
