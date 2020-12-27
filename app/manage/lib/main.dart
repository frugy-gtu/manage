import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding, runApp;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manage/core/cache/auth.dart';
import 'package:path_provider/path_provider.dart';

import 'core/app.dart';
import 'core/cache/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if(kReleaseMode)
      exit(1);
  };
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  await Settings.init();
  await Auth.init();
  runApp(App());
}
