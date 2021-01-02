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

class ManageProjectPath extends ManageRoutePath {
  final String id;
  const ManageProjectPath(this.id);
}

class ManageProjectCreatePath extends ManageRoutePath {
  final String id;
  const ManageProjectCreatePath(this.id);
}

class ManageTeamInvitePath extends ManageRoutePath {
  final String id;
  const ManageTeamInvitePath(this.id);
}

class ManageUserProfileFromTeamsPath extends ManageRoutePath {
  const ManageUserProfileFromTeamsPath();
}

class ManageUserProfileFromTeamPath extends ManageRoutePath {
  final String id;
  const ManageUserProfileFromTeamPath(this.id);
}

class ManageMemberProfilePath extends ManageRoutePath{
  final String teamId;
  final String userId;
  const ManageMemberProfilePath(this.teamId, this.userId);
}

class ManageUnknownPath extends ManageRoutePath {
  const ManageUnknownPath();
}
