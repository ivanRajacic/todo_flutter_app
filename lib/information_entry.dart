import 'package:flutter/material.dart';

class information_entry extends StatefulWidget {
  const information_entry({Key? key}) : super(key: key);

  @override
  State<information_entry> createState() => _information_entryState();
}

class _information_entryState extends State<information_entry> {
  String dropdownValue = "High";
  List<String> _priorityList = ["High", "Medium", "Low"];

  void addCard() {
    Navigator.pop(context, "yea");
  }

  final myControllerName = TextEditingController();
  final myControllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.0),
          child: Column(children: [
            Column(
              children: [
                BackButton(),
                Text("Add Task"),
                TextField(
                  controller: myControllerName,
                  decoration: InputDecoration(
                    hintText: "Title",
                  ),
                ),
                TextField(
                  controller: myControllerDate,
                  decoration: InputDecoration(
                    hintText: "Date",
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: _priorityList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    addCard();
                  },
                  child: const Text('Add'),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
