abstract class ManageRoutePath {
  const ManageRoutePath();
}

class ManageTeamsPath extends ManageRoutePath {
  const ManageTeamsPath();
}

class ManageTeamPath extends ManageRoutePath {
  final String id;

  const ManageTeamPath(this.id);
}

class ManageTeamCreatePath extends ManageRoutePath {
  const ManageTeamCreatePath();
}

class ManageUnknownPath extends ManageRoutePath {
  const ManageUnknownPath();
}
