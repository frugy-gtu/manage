class ResponseResult {
  final Status status;
  final String msg;
  const ResponseResult(this.status, [this.msg = '']);
}

enum Status {
  fail,
  success,
}
