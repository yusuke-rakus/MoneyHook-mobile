class changeEmailClass {
  late String userId = '';
  late String email = '';
  late String password = '';
  String errorMessage = '';
  String emailError = '';
  String passwordError = '';

  changeEmailClass(this.userId, this.email, this.password);

  changeEmailClass.init(this.userId);

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
