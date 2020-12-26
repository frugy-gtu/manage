import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:manage/core/models/validation_item.dart';

class TeamCreateValidation extends ChangeNotifier {
  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _abbrv = ValidationItem(null, null);

  ValidationItem get name => _name;

  ValidationItem get abbrv => _abbrv;

  void updateName(String value) {
    if(value.isNotEmpty && value.length < 3) {
      _name = ValidationItem(null, 'Must be at least 3 characters');
      _abbrv = ValidationItem(null, null);
    }
    else {
      _name = ValidationItem(value, null);
      _abbrv = ValidationItem(_calculateAbbrv(value), null);
    }

    notifyListeners();
  }

  void updateAbbrv(String value) {
    if(value.length > 2) {
      return;
    }

    _abbrv = ValidationItem(value, null);

    notifyListeners();
  }

  String _calculateAbbrv(String name) {
    String abbrv = name[0];
    int index = 0;
    if(name.length < 4) {
      abbrv = name;
    }
    else if(name.contains(' ')) {
      while((index = name.indexOf(' ', index)) != -1 && abbrv.length < 4) {
        if(index < name.length)
          abbrv += name[index+1];
      }
    }
    else if(name.length % 2 == 0) {
      while(index < name.length && index < 5) {
        index += 2;
        abbrv += name[index];
      }
    }
    else {
      abbrv += name[(name.length / 2).ceil()];
    }

    return abbrv;
  }
}
