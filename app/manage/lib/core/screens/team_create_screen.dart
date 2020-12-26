import 'package:flutter/material.dart';
import 'package:manage/core/models/team/team_create_validation.dart';
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
                create: (_) => TeamCreateValidation(), child: TeamForm()),
          ),
        ),
      ),
    );
  }
}

class TeamForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamCreateValidation>(
      builder: (context, validation, child) => Column(children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'name',
            errorText: validation.name.error,
          ),
          inputFormatters: [LengthLimitingTextFieldFormatterFixed(32)],
          onChanged: (value) {
            validation.updateName(value);
          },
          autofocus: true,
        ),
        TextField(
            decoration: InputDecoration(
              hintText: 'abbreviation',
              errorText: validation.abbrv.error,
            ),
            maxLength: 3,
            inputFormatters: [UpperCaseLengthLimitingFormatter(3)],
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              validation.updateAbbrv(value);
            }),
        child
      ]),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Submit'),
      ),
    );
  }
}
