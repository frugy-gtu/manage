import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:manage/core/controller/task_create_controller.dart';
import 'package:manage/core/model/project_state_model.dart';
import 'package:manage/core/model/task_group_model.dart';
import 'package:manage/core/model/team_project_model.dart';
import 'package:manage/extra/length_limiting_text_field_formatter_fixed.dart';
import 'package:manage/extra/widgets/handled_future_builder.dart';
import 'package:manage/core/theme.dart' as manage_theme;
import 'package:manage/extra/widgets/wide_card_button.dart';
import 'package:provider/provider.dart';

class TaskCreateScreen extends StatelessWidget {
  final TaskCreateController _controller;

  TaskCreateScreen(
      {Key key, TeamProjectModel project, ProjectStateModel initialState})
      : _controller =
            TaskCreateController(currentState: initialState, project: project),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary)
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: HandledFutureBuilder(
          future: _controller.requestFormFields(),
          onSuccess: (_) => ChangeNotifierProvider.value(
              value: _controller, child: TaskCreate()),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}

class TaskCreate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskCreateController>(
      builder: (context, controller, child) {
        return SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.name,
                maxLength: 25,
                inputFormatters: [LengthLimitingTextFieldFormatterFixed(25)],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'name',
                  errorText: controller.nameError,
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 30),
              TextField(
                controller: controller.details,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'details',
                  errorText: '',
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 30),
              Column(children: <Widget>[
                Text('Schedule'),
                Theme(
                  data: manage_theme.Theme.currentTheme,
                  child: DateTimeField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: '',
                    ),
                    format: controller.format,
                    onShowPicker: (context, currentValue) =>
                        controller.onShowPicker(context, currentValue),
                    onChanged: (dt) => controller.onScheduleDate(dt),
                  ),
                ),
              ]),
              SizedBox(height: 30),
              Column(children: <Widget>[
                Text('Deadline'),
                Theme(
                  data: manage_theme.Theme.currentTheme,
                  child: DateTimeField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      errorText: '',
                    ),
                    format: controller.format,
                    onShowPicker: (context, currentValue) =>
                        controller.onShowPicker(context, currentValue),
                    onChanged: (dt) => controller.onDeadlineChange(dt),
                  ),
                ),
              ]),
              SizedBox(height: 30),
              DropdownButton<ProjectStateModel>(
                value: controller.currentState,
                onChanged: (newState) => controller.onStateChange(newState),
                hint: Text('Select State',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).colorScheme.secondary)),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
                items: controller.states.map((state) {
                  return DropdownMenuItem<ProjectStateModel>(
                    value: state,
                    child: Text(state.name,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              DropdownButton<TaskGroupModel>(
                hint: Text('Select Group',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Theme.of(context).colorScheme.secondary)),
                value: controller.currentGroup,
                onChanged: (newGroup) => controller.onGroupChange(newGroup),
                items: controller.groups
                    .map<DropdownMenuItem<TaskGroupModel>>((group) {
                  return DropdownMenuItem<TaskGroupModel>(
                    value: group,
                    child: Text(group.name),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
                WideCardButton(
                  child: Text(
                    'Add Task',
                    style: Theme.of(context)
                        .textTheme
                        .button,
                  ),
                  onTap: () {
                    controller.onAddTask(context);
                  },
                )
            ],
          ),
      ),
        );
      },
    );
  }
}
