class ResponseResult<E> {
  final Status status;
  final String msg;
  final E data;
  const ResponseResult(this.status, {this.msg = '', this.data});
}

enum Status {
  fail,
  success,
}
