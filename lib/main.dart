import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/api/api.dart';
import 'package:money_hooks/src/app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Api.initialize();
  runApp(const MyApp());
}
