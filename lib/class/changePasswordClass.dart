class ChangePasswordClass {
  late String userId = '';
  late String password = '';
  late String newPassword = '';
  late String newPassword2 = '';
  String errorMessage = '';
  String passwordError = '';
  String newPasswordError = '';
  String newPassword2Error = '';

  ChangePasswordClass(
      this.userId, this.password, this.newPassword, this.newPassword2);

  ChangePasswordClass.init(this.userId);

  Map<String, String> toJson() {
    return {'userId': userId, 'password': password, 'newPassword': newPassword};
  }

  bool isDisabled() {
    if (password.isEmpty || newPassword.isEmpty || newPassword2.isEmpty) {
      return true;
    }
    if (newPassword != newPassword2) {
      return true;
    }
    return false;
  }

  @override
  String toString() {
    return 'changePasswordClass{userId: $userId, password: $password, newPassword: $newPassword, newPassword2: $newPassword2}';
  }
}
