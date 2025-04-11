class ChangeEmailClass {
  late String userId = '';
  late String email = '';
  late String password = '';
  String errorMessage = '';
  String emailError = '';
  String passwordError = '';

  ChangeEmailClass(this.userId, this.email, this.password);

  ChangeEmailClass.init(this.userId);

  Map<String, String> toJson() {
    return {'userId': userId, 'email': email, 'password': password};
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
    return 'changeEmailClass{userId: $userId, email: $email, password: $password}';
  }
}
