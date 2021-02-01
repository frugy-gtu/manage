import 'package:flutter/material.dart';
import 'package:manage/core/controller/project_create_screen_controller.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/extra/length_limiting_text_field_formatter_fixed.dart';
import 'package:manage/extra/widgets/wide_card_button.dart';
import 'package:provider/provider.dart';

class ProjectCreateScreen extends StatelessWidget {
  final TeamModel team;

  const ProjectCreateScreen(this.team);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight / 9,
              horizontal: constraints.maxWidth / 9,
            ),
            child: ChangeNotifierProvider(
              create: (_) => ProjectCreateScreenController(team),
              child: _ProjectForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectCreateScreenController>(
      builder: (context, controller, child) => Column(children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'name',
            errorText: controller.nameError,
          ),
          controller: controller.name,
          inputFormatters: [LengthLimitingTextFieldFormatterFixed(32)],
          cursorColor: Theme.of(context).colorScheme.secondaryVariant,
          autofocus: true,
        ),
        SizedBox(height: 10,),
        Text(controller.requestError,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: 250,
            minWidth: 200,
            minHeight: 75,
          ),
          child: WideCardButton(
            onTap: () => controller.onCreate(context),
            child: Text(
              'Create',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ]),
    );
  }
}
