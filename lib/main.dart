import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_hooks/app.dart';
import 'package:money_hooks/common/data/api.dart';
import 'package:provider/provider.dart';

import 'common/class/themeProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Api.initialize();
  GoogleFonts.config.allowRuntimeFetching = false;

  final themeProvider = ThemeProvider();
  await themeProvider.initializeFromApi();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const App(),
    ),
  );
}
