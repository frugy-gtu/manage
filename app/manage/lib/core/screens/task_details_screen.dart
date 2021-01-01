import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/model/task_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final TaskModel task;
  TaskDetailsScreen({this.task});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(task.name, style: TextStyle(fontSize: 20.0)),
                    Expanded(child: SizedBox()),
                    Text(task.status.toString().substring(task.status.toString().indexOf('.')+1), style: TextStyle(fontSize: 20.0))
                  ],
                ),
                Divider(color: Colors.black,),
                Text(task.description),
                SizedBox(height: 40.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Task deadline:', style: TextStyle(fontSize: 20.0)),
                    Expanded(child: SizedBox()),
                    Text(formatter.format(DateTime.parse(task.deadLine)), style: TextStyle(fontSize: 20.0)),
                  ],
                ), 
                Divider(color: Colors.black,),
              ],
            ),
          ),
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: SizedBox(
          width: 150.0,
          child: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Back', style: TextStyle(color: Colors.white)),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
