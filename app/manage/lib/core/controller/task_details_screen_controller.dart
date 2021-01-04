import 'package:flutter/cupertino.dart';
import 'package:manage/core/model/comment_model.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/user_profile_model.dart';
import 'package:manage/core/service/request_result.dart';
import 'package:manage/core/service/task_details_service.dart' as service;

class TaskDetailsScreenController extends ChangeNotifier{

  List<CommentModel> commentList;
  TextEditingController commentTextCont = TextEditingController();
  bool validComment = true;

  void addComment(CommentModel comment){
    if(commentList == null){
      commentList = List<CommentModel>();
    }
    commentList.insert(0, comment);
    notifyListeners();
  }

  void isValid(){
    if(commentTextCont.text.isEmpty){
      validComment = false;
    }else{
      validComment = true;
    }
    notifyListeners();
  }

  Future<List<UserProfileModel>> assigneds() async{

  }

  Future<TaskGroupModel> group(String projectID, String groupID) async {
    RequestResult<List<TaskGroupModel>> result = await service.taskGroupsOf(projectID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    return result.data[int.parse(groupID)];
  }
  
  Future<ProjectStateModel> state(String projectID, String stateID) async {
    RequestResult<List<ProjectStateModel>> result = await service.statesOf(projectID);
    if(result.status == Status.fail) {
      throw('Something went wrong ${result.msg}');
    }
    return result.data[int.parse(stateID)];
  }
  

  
}
