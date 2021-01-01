import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/screens/task_details_screen.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/core/screens/user_profile_screen.dart';
import 'package:manage/core/model/task_status_model.dart';


class ProjectScreen extends StatelessWidget {
  final ProjectModel project;

  ProjectScreen({this.project});
  
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPage(),
                  ),
                );
              }
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(child: Text('ToDo', style: TextStyle(color: Colors.black))),
              Tab(child: Text('InProgress', style: TextStyle(color: Colors.black))),
              Tab(child: Text('Done', style: TextStyle(color: Colors.black)))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProjectBody(status: TaskStatus.toDO,),
            ProjectBody(status: TaskStatus.inProgress,),
            ProjectBody(status: TaskStatus.done,)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //Navigator.pushNamed(context, '/taskCreationPage');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.grey,
        ),
        drawer: ThisDrawer(),
      ),
    );
  }
}

class ProjectBody extends StatelessWidget {
  final TaskStatus status;

  ProjectBody({this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:30.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming Tasks', style: TextStyle(fontSize: 20.0)),
              Divider(color: Colors.black,),
              Tasks(upcoming: true, status: status,),
              SizedBox(height: 10.0,),
              Text('Outdated Tasks', style: TextStyle(fontSize: 20.0),),
              Divider(color: Colors.black),
              Tasks(upcoming: false, status: status,),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<TaskModel>> tasks() async{
  //take tasks of this project from db
}

Future<List<TaskModel>> getTaskList(bool upComing, TaskStatus status) async{
  List<TaskModel> allTasks = await tasks();
  List<TaskModel> wantedTasks = List<TaskModel>();

  for(final currentTask in allTasks){
    String taskDeadLine = currentTask.deadLine;
    var taskDate = DateTime.parse(taskDeadLine);
    var now = new DateTime.now();
    if(status == currentTask.status){
      if(!upComing){
        if(taskDate.compareTo(now) < 0){
          wantedTasks.add(currentTask);
        }
      }else{
        if(taskDate.compareTo(now) >= 0){
          wantedTasks.add(currentTask);
        }
      }
    }  
  }
  return wantedTasks;
}

class Tasks extends StatelessWidget {
  final bool upcoming;
  final TaskStatus status;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Tasks({this.upcoming, this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<TaskModel>>(
        future: getTaskList(upcoming, status),
        builder: (context, tasks){
          if(tasks.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.data.length,
              itemBuilder: (context, int position) {
                final currentTask = tasks.data[position];
                final String deadline = formatter.format(DateTime.parse(currentTask.deadLine));
                return Card(
                  color: upcoming ? Colors.green : Colors.red,
                  margin: EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(currentTask.name, style: TextStyle(fontSize: 15.0),),
                        Expanded(child: SizedBox()),
                        Text(deadline, style: TextStyle(fontSize: 15.0),),
                        IconButton(
                          icon: Icon(Icons.navigate_next, color: Colors.white,), 
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsScreen(task: currentTask),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),  
                );
              },
            );
          }else{
            return Center(
              child: Text('No upcoming tasks', style: TextStyle(fontSize: 30.0),)
            );
          }
        }
      ),
    );
  }
}

class ThisDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
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
              ListTile(
                title: Text('Overview', style: TextStyle(color: Colors.white)),
                onTap: (){
                  //Navigator.popAndPushNamed(context, '/overviewPage');
                },
              ),
              ListTile(
                title: Text('Agenda', style: TextStyle(color: Colors.white)),
                onTap: (){
                  //Navigator.popAndPushNamed(context, '/agendaPage');
                },
              ),
              ListTile(
                title: Text('Events', style: TextStyle(color: Colors.white)),
                onTap: (){
                  //Navigator.popAndPushNamed(context, '/eventsPage');
                },
              ),
              ListTile(
                title: Text('Members', style: TextStyle(color: Colors.white)),
                onTap: (){
                  //Navigator.popAndPushNamed(context, '/membersPage');
                },
              ),
              ListTile(
                title: Text('Settings', style: TextStyle(color: Colors.white)),
                onTap: (){
                  //Navigator.popAndPushNamed(context, '/settingsPage');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}