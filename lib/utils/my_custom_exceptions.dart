class CustomHttpException implements Exception {
  String _message;

  CustomHttpException([this._message = 'Failed to get data from server']);

  @override
  String toString() {
    return _message;
  }
}

class DatabaseWriteException implements Exception {
  String _message;

  DatabaseWriteException(
      [this._message = 'Failed to save save quotes to database']);

  @override
  String toString() {
    return _message;
  }
}

class DatabaseReadException implements Exception {
  String _message;

  DatabaseReadException(
      [this._message = 'Failed to save save quotes to database']);

  @override
  String toString() {
    return _message;
  }
}

class NoInternetException implements Exception {
  String _message;

  NoInternetException(
      [this._message = 'No internet connection try again later']);

  @override
  String toString() {
    return _message;
  }
}
