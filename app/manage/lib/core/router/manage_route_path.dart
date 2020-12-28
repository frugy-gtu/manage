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

class ManageTaskCreatePath extends ManageRoutePath {
  const ManageTaskCreatePath();
}

class ManageUnknownPath extends ManageRoutePath {
  const ManageUnknownPath();
}
