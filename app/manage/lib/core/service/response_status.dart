class ResponseStatus {
  final Status status;
  final String msg;
  const ResponseStatus(this.status, [this.msg]);
}

enum Status {
  fail,
  success,
}
