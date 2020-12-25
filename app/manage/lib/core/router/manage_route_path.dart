abstract class ManageRoutePath {}

class ManageTeamPath extends ManageRoutePath {
  final String id;

  ManageTeamPath(this.id);
}

class ManageTeamsPath extends ManageRoutePath {}

class ManageUnknownPath extends ManageRoutePath {}
