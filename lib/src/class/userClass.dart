class userClass {
  late String userId = '';
  late String email = 'sample@sample.com';
  late String password = 'matumoto223';

  userClass(this.userId, this.email, this.password);

  userClass.init();

  Map<String, String> loginJson() {
    return {'email': email, 'password': password};
  }

  @override
  String toString() {
    return 'userClass{userId: $userId, email: $email, password: $password}';
  }
}
