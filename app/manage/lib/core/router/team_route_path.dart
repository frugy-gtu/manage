class TeamRoutePath {
  final String id;
  final bool isUnknown;

  TeamRoutePath.home()
      : id = null,
        isUnknown = false;

  TeamRoutePath.details(this.id) : isUnknown = false;

  TeamRoutePath.unknown()
      : id = null,
        isUnknown = true;


  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;
}
