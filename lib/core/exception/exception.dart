class ResponseException implements Exception {
  final int? code;
  final String? message;

  ResponseException({this.code, this.message});

  @override
  String toString() {
    return "[$code ---$message]";
  }
}
