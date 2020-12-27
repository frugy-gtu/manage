import 'package:flutter/foundation.dart';

class Team {
  final String name;
  final String abbrv;

  const Team({@required this.name, @required this.abbrv});

  factory Team.fromId(String id) {
    return Team(name: 'User Team', abbrv: 'UT');
  }
}
