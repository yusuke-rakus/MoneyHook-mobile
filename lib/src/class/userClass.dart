class userClass {
  late String userId = '';
  late String email = '';
  late String password = '';

  userClass(this.userId, this.email, this.password);
  userClass.init();

  @override
  String toString() {
    return 'userClass{userId: $userId, email: $email, password: $password}';
  }
}
