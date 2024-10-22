import 'package:firebase_core/firebase_core.dart';
import 'utils/constants.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/wrapper/wrapper.dart';
import 'utils/app_theme.dart';

  /// Initializes the Firebase app and runs the application.
  ///
  /// This must be called before using any other Firebase services. It is
  /// recommended to call this in the `main` entry point of the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  /// Returns the root [MaterialApp] for the application.
  ///
  /// This sets up the title, theme, theme mode, and navigator key for the app.
  ///
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Authentication',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      navigatorKey: navigatorkey,
      home: const WrapperWidget(),
    );
  }
}
