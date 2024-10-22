import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import '../authentication/email_verification.dart';
import '../home/homepage.dart';
import '../authentication/login.dart';

class WrapperWidget extends StatelessWidget {
  const WrapperWidget({super.key});

  @override
  /// Returns a Scaffold with a StreamBuilder that listens to the auth state
  /// changes. If the user is signed in and the email is verified, it shows the
  /// HomePage, otherwise it shows the EmailVerification widget. If the user is
  /// not signed in, it shows the LoginPage. If the connection state is waiting,
  /// it shows a CircularProgressIndicator, if there is an error, it shows a
  /// Text with the error message.
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: AuthService().auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (snapshot.data == null) {
                return const LoginPage();
              } else {
                if (snapshot.data?.emailVerified == true) {
                  return const HomePage();
                } else {
                  return const EmailVerification();
                }
              }
            }
          }),
    );
  }
}
