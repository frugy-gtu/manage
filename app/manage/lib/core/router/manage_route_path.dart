abstract class ManageRoutePath {
  const ManageRoutePath();
}

class LoginPath extends ManageRoutePath {
  const LoginPath();
}

class SignUpPath extends ManageRoutePath {
  const SignUpPath();
}

class TeamsPath extends ManageRoutePath {
  const TeamsPath();
}

class ProfilePath extends ManageRoutePath {
  const ProfilePath();
}

class TeamPath extends ManageRoutePath {
  final String id;

  const TeamPath(this.id);
}

class TeamCreatePath extends ManageRoutePath {
  const TeamCreatePath();
}

class ProjectCreatePath extends ManageRoutePath {
  final String id;
  const ProjectCreatePath(this.id);
}

class TeamInvitePath extends ManageRoutePath {
  final String id;
  const TeamInvitePath(this.id);
}

class MemberProfileTeamPath extends ManageRoutePath{
  final String teamId;
  final String memberId;
  const MemberProfileTeamPath(this.teamId, this.memberId);
}

class UnknownPath extends ManageRoutePath {
  const UnknownPath();
}
