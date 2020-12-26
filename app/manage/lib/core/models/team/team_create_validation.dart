import 'package:flutter/foundation.dart';
import 'package:manage/core/models/validation_item.dart';

class TeamCreateValidation extends ChangeNotifier {
  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _abbrv = ValidationItem(null, null);

  ValidationItem get name => _name;

  ValidationItem get abbrv => _abbrv;

  void updateName(String value) {
    if(value.length < 3 && value.length > 0) {
      _name = ValidationItem(null, 'Must be at least 3 characters');
    }
    else {
      _name = ValidationItem(value, null);
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
}
