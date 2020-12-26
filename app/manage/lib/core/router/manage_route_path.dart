abstract class ManageRoutePath {
  const ManageRoutePath();
}

class ManageTeamPath extends ManageRoutePath {
  final String id;

  const ManageTeamPath(this.id);
}

class ManageTeamsPath extends ManageRoutePath {
  const ManageTeamsPath();
}

class ManageUnknownPath extends ManageRoutePath {
  const ManageUnknownPath();
}
