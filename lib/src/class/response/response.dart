class response {
  late String status;
  late String message;

  response(this.status, this.message);

  @override
  String toString() {
    return 'response{status: $status, message: $message}';
  }
}
