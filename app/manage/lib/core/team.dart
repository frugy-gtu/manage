class Team {
  final String name;

  Team(this.name);

  factory Team.fromId(String id) {
    return Team('User Team');
  }
}
