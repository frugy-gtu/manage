import 'package:flutter/material.dart';
import 'package:manage/core/model/team_project_model.dart';

class ProjectScreen extends StatelessWidget {
  final TeamProjectModel project;

  const ProjectScreen(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
    );
  }
}
