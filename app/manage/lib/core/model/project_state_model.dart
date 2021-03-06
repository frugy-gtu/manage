import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:manage/core/model/manage_model.dart';

part 'project_state_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProjectStateModel extends ManageModel {
  final String id;
  final String name;
  final String createdAt;
  final int rank;

  const ProjectStateModel(
      {@required this.name, this.id, this.createdAt, this.rank});

  @override
  String toString() => name;

  bool operator ==(dynamic other) =>
      other != null &&
      other is ProjectStateModel &&
      this.id == other.id &&
      this.name == other.name &&
      this.createdAt == other.createdAt &&
      this.rank == other.rank;

  @override
  int get hashCode => super.hashCode;

  factory ProjectStateModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectStateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectStateModelToJson(this);
}
