import 'package:flutter/material.dart';
import 'package:manage/core/models/team/team_create_validation.dart';
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
      builder: (context, validationService, child) => Column(children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'name',
            errorText: validationService.name.error,
          ),
          onChanged: (value) {
            validationService.updateName(value);
          },
          autofocus: true,
        ),
        TextField(
            decoration: InputDecoration(
              hintText: 'abbreviation',
              errorText: validationService.abbrv.error,
            ),
            maxLength: 3,
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              validationService.updateAbbrv(value);
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
