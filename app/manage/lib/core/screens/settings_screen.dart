import 'package:flutter/material.dart';
import 'package:manage/core/controller/settings_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(automaticallyImplyLeading: false, title: Text('Settings', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
        body: Center(
            child: ChangeNotifierProvider(
                create: (_) => SettingsController(),
                child: _ThemeSelectWidget())));
  }
}

class _ThemeSelectWidget extends StatelessWidget {
  const _ThemeSelectWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, controller, child) => ToggleButtons(
        isSelected: controller.selections,
        color: Theme.of(context).colorScheme.secondary.withAlpha(120),
        selectedColor: Theme.of(context).colorScheme.primary,
        selectedBorderColor: Theme.of(context).colorScheme.secondary.withAlpha(200),
        disabledBorderColor: Theme.of(context).colorScheme.secondary.withAlpha(200),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderColor: Theme.of(context).colorScheme.secondary,
        fillColor: Theme.of(context).colorScheme.secondary,
        children: [
          Icon(Icons.lightbulb),
          Icon(Icons.phone_android),
          Icon(Icons.nightlight_round),
        ],
        onPressed: (index) => controller.onPressed(index),
      ),
    );
  }
}
