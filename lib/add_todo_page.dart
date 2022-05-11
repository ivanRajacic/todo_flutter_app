import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todo.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  String? _selectedPriority;
  final _priorities = ['High', 'Medium', 'Low'];

  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _TitleField(nameController: _titleController),
                _DateField(dateController: _dateController),
                _PriorityField(
                  selectedPriority: _selectedPriority,
                  priorities: _priorities,
                  onUpdatePriority: updatePriority,
                ),
                _AddButton(
                  onPassTodoData: passTodoData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updatePriority(String? newValue) {
    setState(() {
      _selectedPriority = newValue ?? '';
    });
  }

  void passTodoData() {
    if (_selectedPriority != null) {
      Todo data = Todo(
        title: _titleController.text,
        date: _dateController.text,
        priority: _selectedPriority!,
        isChecked: false,
      );
      Navigator.pop(context, data);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    Key? key,
    required TextEditingController nameController,
  })  : _nameController = nameController,
        super(key: key);

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: 'Enter the title of the todo task',
          labelText: 'Title',
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatefulWidget {
  const _DateField({
    Key? key,
    required TextEditingController dateController,
  })  : _dateController = dateController,
        super(key: key);

  final TextEditingController _dateController;

  @override
  State<_DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<_DateField> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget._dateController,
        readOnly: true,
        onTap: () async => _showDatePicker(context),
        decoration: InputDecoration(
          hintText: 'Date',
          labelText: 'Date',
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    {
      final now = DateTime.now();
      final formatter = DateFormat('dd-MM-yyyy');
      _selectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate == null ? now : _selectedDate!,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365 * 30)),
      );

      if (_selectedDate == null) return;

      setState(() {
        widget._dateController.text = formatter.format(_selectedDate!);
      });
    }
  }
}

class _PriorityField extends StatelessWidget {
  const _PriorityField({
    Key? key,
    required String? selectedPriority,
    required List<String> priorities,
    required void Function(String? newValue) onUpdatePriority,
  })  : _selectedPriority = selectedPriority,
        _priorities = priorities,
        _updatePriority = onUpdatePriority,
        super(key: key);

  final String? _selectedPriority;
  final List<String> _priorities;
  final void Function(String? newValue) _updatePriority;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: 'Priority',
          labelText: 'Priority',
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedPriority,
            icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.red,
            ),
            elevation: 8,
            isDense: true,
            hint: const Text('Priority'),
            onChanged: _updatePriority,
            items: _priorities.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    Key? key,
    required void Function() onPassTodoData,
  })  : _passCardData = onPassTodoData,
        super(key: key);

  final void Function() _passCardData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: _passCardData,
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          minimumSize: const Size.fromHeight(60.0),
        ),
        child: const Text(
          'Add',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
