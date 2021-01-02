import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/controller/task_details_screen_controller.dart';
import 'package:manage/core/model/comment_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/user_profile_model.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
  TaskDetailsScreen({this.task});
  
  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
       length: 2,
       child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(child: Text('Comments', style: TextStyle(color: Colors.black)), icon: Icon(Icons.comment, color: Colors.black,),),
              Tab(child: Text('Logged Time', style: TextStyle(color: Colors.black)), icon: Icon(Icons.timelapse, color: Colors.black,),),
            ],
          ),
          body: ChangeNotifierProvider<TaskDetailsScreenController>(
            create: (context) => TaskDetailsScreenController(),   
            child: TabBarView(
              children: [
                TaskDetailsBody(task: task),
                TaskDetailsBody2(task: task),
              ],
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
        ),
     );
  }
}

class TaskDetailsBody extends StatelessWidget {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final TaskModel task;

  TaskDetailsBody({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Text('Task sheculed time:', style: TextStyle(fontSize: 20.0)),
                  Expanded(child: SizedBox()),
                  Text(formatter.format(DateTime.parse(task.scheduledTime)), style: TextStyle(fontSize: 20.0)),
                ],
              ), 
              Divider(color: Colors.black,),
              SizedBox(height: 10.0,),
              Row(
                children: [
                  Text('Task deadline:', style: TextStyle(fontSize: 20.0)),
                  Expanded(child: SizedBox()),
                  Text(formatter.format(DateTime.parse(task.deadLine)), style: TextStyle(fontSize: 20.0)),
                ],
              ), 
              Divider(color: Colors.black,),
              SizedBox(height: 10.0,),
              AssignedsAndCommentsPart()
            ],
          ),
        ),
      ),
    );
  }
}

class AssignedsAndCommentsPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskDetailsScreenController>(
      builder: (context, controller, child) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assigned Members', style: TextStyle(fontSize: 20.0)),
              Divider(color: Colors.black,),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: AssignedMembers(controller: controller,)
              ),
              SizedBox(height: 10.0,),
              Text('Comments', style: TextStyle(fontSize: 20.0)),
              Divider(color: Colors.black,),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: CommentList(controller: controller,)
              ),
              CommentGetter(controller: controller,),
            ],
          ),
        );
      },
    );
  }
}

class CommentGetter extends StatelessWidget {
  final TaskDetailsScreenController controller;

  CommentGetter({this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.commentTextCont,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Add a comment...',
              errorText: controller.validComment ? null : 'You must fill here',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send), 
          onPressed: (){
            controller.isValid();
            if(controller.validComment == true){
              UserProfileModel currentUser = UserProfileModel(username: 'CurrentUs3r',name: 'Current', surname: 'User', profilePhoto: Image.asset('assets/profilePhoto.jpg'));
              CommentModel comment = CommentModel(comment: controller.commentTextCont.text, writer: currentUser);
              controller.addComment(comment);
              controller.commentTextCont.clear();
            }
          }
        )
      ],
    );
  }
}

class AssignedMembers extends StatelessWidget {
  final TaskDetailsScreenController controller;
  AssignedMembers({this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<UserProfileModel>>(
        future: controller.assigneds(),
        builder: (context, assignedMems){
          if(assignedMems.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: assignedMems.data.length,
              itemBuilder: (context, int position){
                final currentUser = assignedMems.data[position];
                return Card(
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(
                      children: [
                        Container(
                          child: CircleAvatar(
                            backgroundImage: currentUser.profilePhoto.image,
                            radius: 20,
                          ), 
                        ),
                        SizedBox(width: 10.0),
                        Text(currentUser.name + ' ' + currentUser.surname, style: TextStyle(fontSize: 15.0)),
                        Expanded(child: SizedBox()),
                        IconButton(
                          icon: Icon(Icons.account_circle, size: 20.0),
                          onPressed: (){
                          //  context.read<ManageRouteState>().update(ManageRoute.member_profile, prevRoute: ManageRoute.task_detail)
                          }
                        )
                      ],
                    ),
                  ),
                ); 
              }
            );
          }else{
            return SizedBox(height: 20.0,);
          }
        }
      )  
    );
  }
}

class CommentList extends StatelessWidget {

  final TaskDetailsScreenController controller;

  CommentList({this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.commentList != null ? controller.commentList.length : 0,
        itemBuilder: (context, int position){
          final currentComment = controller.commentList[position];
          return Card(
            margin: EdgeInsets.all(5.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundImage: currentComment.writer.profilePhoto.image,
                          radius: 20,
                        ),
                      ), 
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentComment.writer.name + ' ' + currentComment.writer.surname, style: TextStyle(fontSize:  16.0, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5.0,),
                            Text(currentComment.comment, style: TextStyle(fontSize: 15.0)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class TaskDetailsBody2 extends StatelessWidget {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final TaskModel task;

  TaskDetailsBody2({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              SizedBox(height: 50.0,),
              LoggedTime(),
            ],
          ),
        ),
      ),
    );
  }
}


class LoggedTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Logged Time: ', style: TextStyle(fontSize: 20.0),),
    );
  }
}


