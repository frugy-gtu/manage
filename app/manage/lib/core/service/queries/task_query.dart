import 'package:json_annotation/json_annotation.dart';

part 'task_query.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TaskQuery {
  final String projectId;
  final String taskGroupId;
  final String stateId;

  const TaskQuery({
    this.projectId,
    this.taskGroupId,
    this.stateId,
  });

  factory TaskQuery.fromJson(Map<String, dynamic> json) =>
      _$TaskQueryFromJson(json);

  Map<String, dynamic> toJson() => _$TaskQueryToJson(this);
}
