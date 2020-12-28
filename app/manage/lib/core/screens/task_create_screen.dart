import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:manage/core/router/manage_route.dart';
import 'package:manage/core/router/manage_route_state.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Future<http.Response> createTask(
    String name, String details, String deadline) async {
  final res = await http.post(
    'https://jsonplaceholder.typicode.com/tasks',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'details': details,
      'deadline': deadline,
    }),
  );
}

class TaskCreateScreen extends StatefulWidget {
  TaskCreateScreen({Key key}) : super(key: key);

  final String title = "Manage";

  @override
  _TaskCreateScreenState createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          child: TaskCreate(),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}

class TaskCreate extends StatefulWidget {
  @override
  _TaskCreateState createState() => _TaskCreateState();
}

class _TaskCreateState extends State<TaskCreate> {
  final number = TextEditingController();
  DateTime date1 = DateTime.now();
  final TextEditingController _tasknameController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();
  final FocusNode _tasknameFocusNode = FocusNode();
  final FocusNode _defFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();

  String get _taskname => _tasknameController.text;
  void _nameComplete() {
    FocusScope.of(context).requestFocus(_defFocusNode);
  }

  void _defComplete() {
    FocusScope.of(context).requestFocus(_dateFocusNode);
  }

  void _dateComplete() {
    FocusScope.of(context).requestFocus(_submitFocusNode);
  }

  void _notComplete() {
    FocusScope.of(context).requestFocus(_tasknameFocusNode);
  }

  void _submit() {
    print(date1);
    {
      createTask(_tasknameController.text, _definitionController.text,
          date1.toString());
      // TODO : add next page to move
    }
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = _taskname.isNotEmpty;

    return [
      TextField(
        controller: _tasknameController,
        focusNode: _tasknameFocusNode,
        maxLength: 25,
        maxLengthEnforced: true,
        decoration: InputDecoration(
            labelText: 'Task Name', hintText: 'Enter Task Name Here'),
        autocorrect: false,
        textInputAction: TextInputAction.next,
        onEditingComplete: _nameComplete,
      ),
      TextField(
        controller: _definitionController,
        focusNode: _defFocusNode,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Enter Description Here',
        ),
        autocorrect: false,
        textInputAction: TextInputAction.next,
        onEditingComplete: _defComplete,
      ),
      DateTimePickerFormField(
        focusNode: _dateFocusNode,
        keyboardType: TextInputType.datetime,
        inputType: InputType.both,
        format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
        editable: false,
        firstDate: DateTime.now(),
        decoration: InputDecoration(
          labelText: 'DateTime',
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        onChanged: (dt) {
          setState(() => date1 = dt);
          print('Selected date: $date1');
          submitEnabled ? _dateComplete() : _notComplete();
        },
      ),
      SizedBox(height: 30),
      RaisedButton(
        focusNode: _submitFocusNode,
        child: Text(
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: submitEnabled ? _submit : null,
        color: Colors.indigo,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
