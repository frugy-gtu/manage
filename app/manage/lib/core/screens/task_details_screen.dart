import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/model/task_model.dart';

import 'controller/task_details_screen_controller.dart';


class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
  TaskDetailsScreen({this.task});
  
  @override
  Widget build(context) {
     return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(task.name, style: TextStyle(fontSize: 20.0, color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: TaskDetailsBody(task: task),        
    );
  }
}

class TaskDetailsBody extends StatelessWidget {
  final TaskDetailsScreenController _controller = TaskDetailsScreenController();
  final TaskModel task;

  TaskDetailsBody({this.task});

  @override
  Widget build(context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: Future.wait([_controller.group(task.projectId, task.taskGroupId), _controller.state(task.projectId, task.taskStateId)]),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final String _group = snapshot.data[0];
                    final String _state = snapshot.data[1];
                    return Row(
                      children: [
                        Text(_group, style: TextStyle(fontSize: 20.0, color: Colors.black)),
                        Expanded(child: SizedBox()),
                        Text(_state, style: TextStyle(fontSize: 20.0, color: Colors.black)),
                      ],
                    );
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Divider(color: Colors.black,),
              Card(
                color: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(child: Text(task.details)),
                    ],
                  ),
                )
              ),
              SizedBox(height: 10.0,),
              DatePart(task: task,),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePart extends StatelessWidget {
  final DateFormat dayFormatter = DateFormat('yyyy/MM/dd');
  final DateFormat hourFormatter = DateFormat('HH:mm a');
  final TaskModel task;

  DatePart({this.task});

  @override
  Widget build(context) {
    return Row(
      children:[
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Sheculed time', style: TextStyle(fontSize: 20.0)),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      Expanded(child: SizedBox()),
                      Text(dayFormatter.format(DateTime.parse(task.schedule)), style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      Expanded(child: SizedBox(),),
                      Text(hourFormatter.format(DateTime.parse(task.schedule)), style: TextStyle(fontSize: 15.0)),
                    ],
                  ),  
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Deadine', style: TextStyle(fontSize: 20.0)),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      Expanded(child: SizedBox()),
                      Text(dayFormatter.format(DateTime.parse(task.deadline)), style: TextStyle(fontSize: 15.0)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      Expanded(child: SizedBox(),),
                      Text(hourFormatter.format(DateTime.parse(task.deadline)), style: TextStyle(fontSize: 15.0)),
                    ],
                  ),  
                ],
              ),
            ),
          ),
        ),
      ],   
    );
  }
}
