import 'dart:async';
import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import '../wrapper/wrapper.dart';
import 'widgets/auth_widgets.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  User? user;
  final AuthService _authService = AuthService();
  Timer? _timer;

  @override
  /// This method is called when the widget is inserted into the tree.
  ///
  /// It sets the user to the user currently logged in, sends a verification
  /// email to the user, and starts checking every 5 seconds to see if the
  /// user has verified their email. If the user has verified their email, it
  /// cancels the timer and navigates to the WrapperWidget.
  void initState() {
    super.initState();
    user = _authService.user;
    _authService.sendVerificationEmail();
    _startEmailVerificationCheck();
  }

  /// This method starts a timer that checks every 5 seconds if the user has
  /// verified their email. If the user has verified their email, it cancels
  /// the timer and navigates to the WrapperWidget.
  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _authService.reload();
      if (_authService.user?.emailVerified == true) {
        user = _authService.user;
        _timer?.cancel();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WrapperWidget()));
      }
    });
  }

  @override
/// Disposes of the resources used by the EmailVerification widget.
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  /// Builds the EmailVerification widget.
  ///
  /// This widget shows the user a message telling them to verify their email
  /// ID, a resend button to resend the verification email, and a sign out
  /// button to go back to the sign in page.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  ///
  /// Returns:
  /// A `cardWidget` with a `Column` child that contains the message and the
  /// buttons.
  Widget build(BuildContext context) {
    double scHeight = MediaQuery.sizeOf(context).height;
    double scWidth = MediaQuery.sizeOf(context).width;
    return cardWidget(
      scHeight: scHeight,
      scWidth: scWidth,
      action: null,
      child: Column(
        children: [
          titleText('Please Verify Your Email ID'),
          const SizedBox(height: 10),
          const Icon(
            Icons.mail,
            color: Colors.white,
            size: 100,
          ),
          const SizedBox(height: 10),
          Text(
            textAlign: TextAlign.center,
            'We Have Sent You An Verification Email to Your Email ID ${user!.email}. Please Verify it Soon!',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(
            height: 20,
          ),
          authButton(
              scWidth: scWidth,
              text: 'Resend Email',
              onPressed: () async {
                await _authService.sendVerificationEmail();
                _startEmailVerificationCheck();
              }),
          const SizedBox(
            height: 20,
          ),
          authButton(
              scWidth: scWidth,
              text: 'Go Back to Sign In',
              onPressed: () {
                _authService.signOut();
              })
        ],
      ),
    );
  }
}
