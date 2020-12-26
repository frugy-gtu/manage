import 'package:flutter/material.dart';
import 'package:manage/core/controller/team_create_controller.dart';
import 'package:manage/extra/length_limiting_text_field_formatter_fixed.dart';
import 'package:manage/extra/upper_case_length_limiting_formatter.dart';
import 'package:provider/provider.dart';

class TeamCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight / 9,
              horizontal: constraints.maxWidth / 9,
            ),
            child: ChangeNotifierProvider(
                create: (_) => TeamCreateController(), child: TeamForm()),
          ),
        ),
      ),
    );
  }
}

class TeamForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamCreateController>(
      builder: (context, controller, child) => Column(children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'name',
            errorText: controller.nameError,
          ),
          controller: controller.name,
          inputFormatters: [LengthLimitingTextFieldFormatterFixed(32)],
          autofocus: true,
        ),
        TextField(
            decoration: InputDecoration(
              hintText: 'abbreviation',
              labelText: 'abbreviation',
            ),
            controller: controller.abbrv,
            onTap: () { controller.isAbbrvEdited = true; },
            maxLength: 3,
            inputFormatters: [UpperCaseLengthLimitingFormatter(3)],
            textCapitalization: TextCapitalization.characters,
          ),
        child
      ]),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Create'),
      ),
    );
  }
}
