class Team {
  final String name;

  const Team(this.name);

  factory Team.fromId(String id) {
    return Team('User Team');
  }
}
