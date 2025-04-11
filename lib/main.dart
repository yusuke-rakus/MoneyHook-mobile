import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_hooks/app.dart';
import 'package:money_hooks/common/data/api.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Api.initialize();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const App());
}
