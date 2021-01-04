import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage/core/model/comment_model.dart';
import 'package:manage/core/model/task_model.dart';
import 'package:manage/core/model/user_profile_model.dart';
import 'package:provider/provider.dart';

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
      body: ChangeNotifierProvider<TaskDetailsScreenController>(
        create: (context) => TaskDetailsScreenController(),   
        child: TaskDetailsBody(task: task),      
      ),
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
              Consumer<TaskDetailsScreenController>(
                builder: (context, controller, child) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text('Comments', style: TextStyle(fontSize: 20.0))),
                        Divider(color: Colors.black,),
                        CommentList(controller: controller,),
                        CommentGetter(controller: controller,),
                      ],
                    ),
                  );
                },
              ),
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

class CommentGetter extends StatelessWidget {
  final TaskDetailsScreenController controller;

  CommentGetter({this.controller});

  @override
  Widget build(context) {
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
              UserProfileModel currentUser = UserProfileModel(userName: 'CurrentUs3r',name: 'Current', surname: 'User', profilePhoto: Image.asset('assets/profilePhoto.jpg'));
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
  Widget build(context) {
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
                  color: Theme.of(context).colorScheme.primary,
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
  Widget build(context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: controller.commentList != null ? controller.commentList.length : 0,
        itemBuilder: (context, int position){
          final currentComment = controller.commentList[position];
          return Card(
            color: Theme.of(context).colorScheme.primary,
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


