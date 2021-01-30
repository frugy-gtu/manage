import 'package:flutter/material.dart';
import 'package:manage/core/controller/team_invite_screen_controller.dart';
import 'package:manage/core/model/team_model.dart';
import 'package:manage/extra/widgets/wide_card_button.dart';
import 'package:provider/provider.dart';

class TeamInviteScreen extends StatelessWidget {
  final TeamModel team;

  const TeamInviteScreen(this.team);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.secondary)
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => Padding(
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight / 9,
              horizontal: constraints.maxWidth / 9,
            ),
            child: ChangeNotifierProvider(
              create: (_) => TeamInviteScreenController(team),
              child: _MemberForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamInviteScreenController>(
      builder: (context, controller, child) => Column(children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'username',
            errorText: controller.uNameError,
          ),
          controller: controller.uName,
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
              'Invite',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ]),
    );
  }
}
