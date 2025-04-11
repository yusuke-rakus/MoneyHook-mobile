import 'package:money_hooks/class/response/response.dart';

class Login extends Response {
  String userId;

  Login(super.status, super.message, this.userId);
}
