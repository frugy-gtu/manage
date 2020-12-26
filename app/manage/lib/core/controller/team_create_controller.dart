import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class TeamCreateController extends ChangeNotifier {
  final TextEditingController _name;
  final TextEditingController _abbrv;
  String _nameError;
  bool isAbbrvEdited = false;

  TeamCreateController()
      : _name = TextEditingController(),
        _abbrv = TextEditingController() {
    _name.addListener(_nameCallback);
  }

  TextEditingController get name => _name;

  String get nameError => _nameError;

  TextEditingController get abbrv => _abbrv;

  void _nameCallback() {
    if (_name.text.isNotEmpty && _name.text.length < 3) {
      _nameError = 'Must be at least 3 characters';
    } else {
      _nameError = null;
    }

    if (_abbrv.text.isEmpty && _name.text.isNotEmpty) isAbbrvEdited = false;
    if (_abbrv.text.isEmpty || !isAbbrvEdited) {
      _abbrv.text = _calculateAbbrv(_name.text);
    }

    notifyListeners();
  }

  String _calculateAbbrv(String name) {
    if (name == null || name.isEmpty) return '';

    String abbrv = name[0];
    int index = 0;
    if (name.contains(' ')) {
      while ((index = name.indexOf(' ', index)) != -1 && abbrv.length < 3) {
        ++index;
        if (index < name.length) abbrv += name[index];
      }
    } else if (name.length < 4) {
      abbrv = name;
    } else if (name.length % 2 == 0) {
      while (index + 2 < name.length && index + 2 < 5) {
        index += 2;
        abbrv += name[index];
      }
    } else {
      abbrv += name[(name.length / 2).ceil()];
    }

    return abbrv.toUpperCase();
  }

  @override
  void dispose() {
    name.dispose();
    abbrv.dispose();
    super.dispose();
  }
}
