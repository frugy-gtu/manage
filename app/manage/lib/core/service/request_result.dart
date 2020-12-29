class RequestResult<E> {
  final Status status;
  final String msg;
  final E data;
  const RequestResult(this.status, {this.msg = '', this.data});

  factory RequestResult.cast(RequestResult other) {
    return RequestResult(other.status, msg: other.msg, data: other.data);
  }

  RequestResult<T> castTo<T>() => RequestResult<T>.cast(this);
}

enum Status {
  fail,
  success,
}
