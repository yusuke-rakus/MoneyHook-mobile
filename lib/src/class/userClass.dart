class userClass {
  late String userId = '';
  late String email = 'sample@sample.com';
  late String password = 'matumoto223';
  String errorMessage = '';

  userClass(this.userId, this.email, this.password);

  userClass.init();

  Map<String, String> loginJson() {
    return {'email': email, 'password': password};
  }

  bool isDisabled() {
    if (email.isEmpty || password.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return 'userClass{userId: $userId, email: $email, password: $password}';
  }
}
