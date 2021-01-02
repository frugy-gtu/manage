import 'package:flutter/cupertino.dart';
import 'package:manage/core/model/comment_model.dart';
import 'package:manage/core/model/user_profile_model.dart';

class TaskDetailsScreenController extends ChangeNotifier{

  List<CommentModel> commentList;
  TextEditingController commentTextCont = TextEditingController();
  bool validComment = true;

  void addComment(CommentModel comment){
    if(commentList == null){
      commentList = List<CommentModel>();
    }
    commentList.add(comment);
    notifyListeners();
  }
  
  Future<List<UserProfileModel>> assigneds() async{
    
  }

  Future<List<CommentModel>> comments() async{

  }

  void isValid(){
    if(commentTextCont.text.isEmpty){
      validComment = false;
    }else{
      validComment = true;
    }
    notifyListeners();
  }

}
