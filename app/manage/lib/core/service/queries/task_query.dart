import 'package:json_annotation/json_annotation.dart';

part 'task_query.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskQuery {
  final String projectId;
  final String taskGroupId;

  const TaskQuery({this.projectId, this.taskGroupId,});

  factory TaskQuery.fromJson(Map<String, dynamic> json) =>
      _$TaskQueryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskQueryToJson(this);
}
