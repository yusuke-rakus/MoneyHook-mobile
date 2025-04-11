class Response {
  late String status;
  late String message;

  Response(this.status, this.message);

  @override
  String toString() {
    return 'response{status: $status, message: $message}';
  }
}
