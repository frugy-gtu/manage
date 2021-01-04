import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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
        child: SingleChildScrollView(
          child: Card(
            child: TaskCreate(),
          ),
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
  DateTime schedule = DateTime.now();
  DateTime duedate;
  String selectedState;   // TODO : Initialize state here and group below
  String selectedGroup;
  final TextEditingController _tasknameController = TextEditingController();
  final TextEditingController _definitionController = TextEditingController();
  final FocusNode _tasknameFocusNode = FocusNode();
  final FocusNode _defFocusNode = FocusNode();
  final FocusNode _submitFocusNode = FocusNode();
  final FocusNode _scheduleFocusNode = FocusNode();
  final FocusNode _duedateFocusNode = FocusNode();

  final format = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  String get _taskname => _tasknameController.text;
  void _nameComplete() {
    FocusScope.of(context).requestFocus(_defFocusNode);
  }

  void _defComplete() {
    FocusScope.of(context).requestFocus(_duedateFocusNode);
  }

  void _duedateComplete() {
    FocusScope.of(context).requestFocus(_submitFocusNode);
  }

  void _scheduleComplete() {
    FocusScope.of(context).requestFocus(_duedateFocusNode);
  }

  void _submit() {
    print(schedule);
    print(duedate);
    print(selectedState);
    print(selectedGroup);
    {
      createTask(_tasknameController.text, _definitionController.text,
          duedate.toString());
      // TODO : add next page to move
    }
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = _taskname.isNotEmpty && duedate != null;

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
          labelText: 'Details',
          hintText: 'Enter Details Here',
        ),
        autocorrect: false,
        textInputAction: TextInputAction.next,
        onEditingComplete: _defComplete,
      ),
      SizedBox(height: 30),
      Column(children: <Widget>[
        Text('Deadline'),
        DateTimeField(
          focusNode: _duedateFocusNode,
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: new DateTime.now(),
                lastDate: DateTime(2050));
            if (date != null) {
              final time = await showTimePicker(
                  context: context,
                  initialTime: new TimeOfDay(hour: 0, minute: 0));
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
          onEditingComplete: _duedateComplete,
          onChanged: (dt) {
            setState(() => duedate = dt);
            print('Selected date: $duedate');
          },
        ),
      ]),
      SizedBox(height: 30),
      Column(children: <Widget>[
        Text('Schedule Date'),
        DateTimeField(
          focusNode: _scheduleFocusNode,
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2010),
                initialDate: DateTime.now(),
                lastDate: duedate != null ? duedate : DateTime(2050));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
          onEditingComplete: _scheduleComplete,
          onChanged: (dt) {
            setState(() => schedule = dt);
            print('Selected date: $schedule');
          },
        ),
      ]),
      SizedBox(height: 30),
      DropdownButton<String>(
        value: selectedState,
        onChanged: (String newValue) {
          setState(() {
            selectedState = newValue;
          });
        },
        items: .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      SizedBox(height: 30),
      DropdownButton<String>(
        value: selectedGroup,
        onChanged: (String newValue) {
          setState(() {
            selectedGroup = newValue;
          });
        },
        items: .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      SizedBox(height: 30),
      RaisedButton(
        focusNode: _submitFocusNode,
        child: Text(
          'Submit',
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        onPressed: submitEnabled ? _submit : null,
        color: Theme.of(context).buttonColor,
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
