import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage/core/controller/team_create_screen_controller.dart';
import 'package:manage/extra/length_limiting_text_field_formatter_fixed.dart';
import 'package:manage/extra/upper_case_length_limiting_formatter.dart';
import 'package:manage/extra/widgets/wide_card_button.dart';
import 'package:provider/provider.dart';

class TeamCreateScreen extends StatelessWidget {
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
              create: (_) => TeamCreateScreenController(),
              child: TeamForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class TeamForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamCreateScreenController>(
      builder: (context, controller, child) => Column(children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'name',
            errorText: controller.nameError,
          ),
          controller: controller.name,
          inputFormatters: [
            LengthLimitingTextFieldFormatterFixed(12),
            FilteringTextInputFormatter.allow(RegExp('[a-z0-9A-Z\-]')),
          ],
          cursorColor: Theme.of(context).colorScheme.secondaryVariant,
          autofocus: true,
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'abbreviation',
            labelText: 'abbreviation',
            errorText: controller.abbrvError,
          ),
          controller: controller.abbrv,
          onTap: () {
            controller.isAbbrvEdited = true;
          },
          maxLength: 3,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9A-Za-z]')),
            UpperCaseLengthLimitingFormatter(3),
          ],
          textCapitalization: TextCapitalization.characters,
          cursorColor: Theme.of(context).colorScheme.secondaryVariant,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          controller.requestError,
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
