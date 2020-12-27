import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'userPage.dart';

import 'temps/task.dart';

class TaskDetails extends StatefulWidget {
  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  TextEditingController _commentCont;
  bool _validComment = true;
  Task task;
  List<Comment> comments;
  List<UserProfile> assigneds = [
    UserProfile(name: 'ali', lName: 'veli', photo: Icons.account_circle),
    UserProfile(name: 'mehmet', lName: 'seyir', photo: Icons.account_balance)
  ];

  void initState(){
    super.initState();
    _commentCont = TextEditingController();
    comments = List<Comment>();
    task = Task(name: 'Task Details', description: 'Users can see task details', deadLine: '26.12.2020', status: TaskStatus.toDo, assigneds: assigneds, comments: comments);
  }

  void dispose(){
    _commentCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ChangeNotifierProvider(
            create: (context) => Task.cp(task),
            child: Consumer<Task>(
              builder: (context, task, child){
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(task.name),
                          Expanded(child: SizedBox()),
                          Text(task.status.toString().substring(task.status.toString().indexOf('.')+1))
                        ],
                      ),
                      Divider(color: Colors.black,),
                      Text(task.description),
                      SizedBox(height: 40.0,),
                      Text('Task deadline: ' + task.deadLine),
                      Divider(color: Colors.black,),
                      SizedBox(height: 20.0,),
                      Text('Assigned Members', style: TextStyle(fontSize: 20.0)),
                      Divider(color: Colors.black),
                      AssignedMembers(task: task),
                      Text('Comments', style: TextStyle(fontSize: 20.0)),
                      Divider(color: Colors.black),
                      Comments(task: task),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentCont,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Add a comment...',
                                errorText: _validComment ? null : 'You must fill here',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send), 
                            onPressed: (){
                              setState(() {
                                _commentCont.text.isEmpty ? _validComment = false : _validComment = true;
                              });
                              if(_validComment == true){
                                UserProfile currentUser = UserProfile(name: 'Current', lName: 'User', photo: Icons.account_circle);
                                Comment comment = Comment(comment: _commentCont.text, writer: currentUser);
                                task.addComment(comment);
                                _commentCont.clear();
                              }
                            }
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }             
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

class Comments extends StatelessWidget {
  final Task task;

  Comments({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: FutureBuilder<List<Comment>>(
        future: task.getComments(),
        builder: (context, comments){
          if(comments.hasData){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: comments.data.length,
              itemBuilder: (context, int position){
                final currentComment = comments.data[position];
                return Card(
                  margin: EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                      future: Future.wait([currentComment.getComment(), currentComment.getWriter()]),
                      builder: (context, currentComment){
                        if(currentComment.hasData){
                          final String comment = currentComment.data[0];
                          final UserProfile writer = currentComment.data[1];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: Future.wait([writer.getPhoto(), writer.getName(), writer.getLName()]),
                                builder: (context, writer){
                                  if(writer.hasData){
                                    Icon photo = Icon(writer.data[0], size: 15.0);
                                    String name = writer.data[1];
                                    String lName = writer.data[2];
                                    return Row(
                                      children: [
                                        photo,
                                        SizedBox(width: 10.0),
                                        Text(name + ' ', style: TextStyle(fontSize:  15.0),),
                                        Text(lName + ' ', style: TextStyle(fontSize:  15.0),),
                                      ],
                                    );
                                  }else{
                                    return Center(
                                      child: Text('Could not access writer data', style: TextStyle(fontSize: 15.0),),
                                    );
                                  }
                                }
                              ),
                              SizedBox(height: 5.0,),
                              Text(comment, style: TextStyle(fontSize: 15.0)),
                            ],
                          );
                        }else{
                          return Center(
                            child: Text('Could not access comment data', style: TextStyle(fontSize: 15.0),),
                          );
                        }
                      }
                    ),
                  ),
                );
              }
            );
          }else{
            return Center(
              child: Text('No Comments', style: TextStyle(fontSize: 15.0),),
            );
          }
        }
      )  
    );
  }
}

class AssignedMembers extends StatelessWidget {
  final Task task;

  AssignedMembers({this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: FutureBuilder<List<UserProfile>>(
        future: task.getAssignedMems(),
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
                    child: FutureBuilder(
                      future: Future.wait([currentUser.getPhoto(), currentUser.getName(), currentUser.getLName()]),
                      builder: (context, currentMember){
                        if(currentMember.hasData){
                          Icon photo = Icon(currentMember.data[0], size:15.0);
                          String name = currentMember.data[1];
                          String lName = currentMember.data[2];
                          return Row(
                            children: [
                              photo,
                              SizedBox(width: 10.0),
                              Text(name + ' ', style: TextStyle(fontSize: 15.0)),
                              Text(lName + ' ', style: TextStyle(fontSize: 15.0)),
                              Expanded(child: SizedBox()),
                              IconButton(
                                icon: Icon(Icons.account_circle, size: 20.0),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserPage(user: currentUser),
                                    ),
                                  );
                                }
                              )
                            ],
                          );
                        }else{
                          return Center(
                            child: Text('Could not access user infos', style: TextStyle(fontSize: 15.0))
                          );
                        }
                      }
                    ),
                  ),
                ); 
              }
            );
          }else{
            return Center(
              child: Text('Not assigned anyone', style: TextStyle(fontSize: 15.0),),
            );
          }
        }
      )  
    );
  }
}