import 'package:money_hooks/src/class/response/response.dart';

class login extends response {
  String userId;

  login(super.status, super.message, this.userId);
}
