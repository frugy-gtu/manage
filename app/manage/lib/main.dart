import 'package:flutter/widgets.dart' show runApp;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/manage_app.dart';

void main() async {
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  runApp(ManageApp());
}
