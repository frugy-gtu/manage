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

class SettingsPath extends ManageRoutePath {
  const SettingsPath();
}

class ProjectsPath extends ManageRoutePath {
  const ProjectsPath();
}

class TeamPath extends ManageRoutePath {
  final String id;

  const TeamPath(this.id);
}

class TeamCreatePath extends ManageRoutePath {
  const TeamCreatePath();
}

class ProjectTeamPath extends ManageRoutePath {
  final String teamId;
  final String projectId;
  const ProjectTeamPath(this.teamId, this.projectId);
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

class TaskDetailsTeamPath extends ManageRoutePath{
  final String teamId;
  final String projectId;
  final String taskId;
  const TaskDetailsTeamPath(this.teamId, this.projectId, this.taskId);
}

class TaskDetailsProjectPath extends ManageRoutePath{
  final String projectId;
  final String taskId;
  const TaskDetailsProjectPath(this.projectId, this.taskId);
}
class UnknownPath extends ManageRoutePath {
  const UnknownPath();
}
