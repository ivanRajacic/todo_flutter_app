import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //glavni container
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Add Card',
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.0),
          child: Column(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("My Tasks"),
                Text("Counter"),
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
