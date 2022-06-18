abstract class Result<T> {}

class Success<T> implements Result<T> {
  final T data;

  Success(this.data);
}

class Error<T> implements Result<T> {
  final Exception exception;

  Error(this.exception);
}
