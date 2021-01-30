import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/controller/task_details_screen_controller.dart';
import 'package:manage/core/model/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
  TaskDetailsScreen({this.task});
  
  @override
  Widget build(context) {
     return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(task.name, style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.secondary),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: Center(child: TaskDetailsBody(task: task)),        
    );
  }
}

class TaskDetailsBody extends StatelessWidget {
  final TaskDetailsScreenController controller = TaskDetailsScreenController();
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
                future: Future.wait([controller.group(task.projectId, task.taskGroupId), controller.state(task.projectId, task.taskStateId)]),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    final String _group = snapshot.data[0].name;
                    final String _state = snapshot.data[1].name;
                    return Row(
                      children: [
                        Text(_group, style: Theme.of(context).textTheme.bodyText1,),
                        Expanded(child: SizedBox()),
                        Text(_state, style: Theme.of(context).textTheme.bodyText1),
                      ],
                    );
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Divider(color: Theme.of(context).colorScheme.secondary,),
              Card(
                color: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(child: Details(details: task.details,),),                  
                    ],
                  ),
                )
              ),
              SizedBox(height: 10.0,),
              DatePart(task: task,),
              SizedBox(height: 80.0,),
            ],
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String details;

  Details({this.details});

  @override
  Widget build(BuildContext context) {
    if(details == null || details == ''){
      return Text('No details...', style: TextStyle(color: Theme.of(context).colorScheme.primary),);
    }else{
      return Text(details, style: TextStyle(color: Theme.of(context).colorScheme.primary),);
    }
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
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Sheculed time', style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.primary)),
                  Divider(color: Theme.of(context).colorScheme.primary),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary,),
                      Expanded(child: SizedBox()),
                      Text(dayFormatter.format(DateTime.parse(task.schedule)), style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Theme.of(context).colorScheme.primary,),
                      Expanded(child: SizedBox(),),
                      Text(hourFormatter.format(DateTime.parse(task.schedule)), style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),  
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Deadine', style: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.primary)),
                  Divider(color: Theme.of(context).colorScheme.primary),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary,),
                      Expanded(child: SizedBox()),
                      Text(dayFormatter.format(DateTime.parse(task.deadline)), style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Theme.of(context).colorScheme.primary,),
                      Expanded(child: SizedBox(),),
                      Text(hourFormatter.format(DateTime.parse(task.deadline)), style: TextStyle(fontSize: 15.0, color: Theme.of(context).colorScheme.primary)),
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
