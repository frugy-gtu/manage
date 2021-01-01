abstract class ManageRoutePath {
  const ManageRoutePath();
}

class ManageLoginPath extends ManageRoutePath {
  const ManageLoginPath();
}

class ManageSignUpPath extends ManageRoutePath {
  const ManageSignUpPath();
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

class ManageProfilePath extends ManageRoutePath{
  const ManageProfilePath();
}

class ManageUnknownPath extends ManageRoutePath {
  const ManageUnknownPath();
}
