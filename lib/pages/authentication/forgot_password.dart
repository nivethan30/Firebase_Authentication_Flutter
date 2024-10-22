import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import '../../widgets/alerts.dart';
import 'widgets/auth_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailIdController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final AuthService _authService = AuthService();

  /// Sends the password reset email to the user if the email is valid.
  ///
  /// Calls [AuthService.sendPasswordResetEmail] with the given email address.
  /// If the email is sent successfully, it pops the current context and shows
  /// an alert dialog with a success message.
  Future<void> _sendResetEmail(String email) async {
    final bool isMailSent = await _authService.sendPasswordResetEmail(email);
    if (isMailSent) {
      _popContext();
      alertWidget(
          title: 'Mail Sent', text: 'Password Reset Email Sent Successfully');
    }
  }

  /// Pops the current context.
  ///
  /// This function is used to go back to the previous screen when the password
  /// reset email is sent successfully. It uses [Navigator.pop] to pop the
  /// current context.
  void _popContext() {
    Navigator.pop(context);
  }

  @override
/// Disposes of the resources used by the `_ForgotPasswordState` widget.
  void dispose() {
    _emailIdController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  /// Builds the forgot password widget.
  ///
  /// This widget shows the user a title, an icon, a text, a text field to enter
  /// the email ID and a button to send the password reset email. If the email
  /// ID is valid, it calls [AuthService.sendPasswordResetEmail] with the given
  /// email ID. If the email is sent successfully, it pops the current context
  /// and shows an alert dialog with a success message.
  ///
  /// The widget also has a back button to go back to the sign in screen. If the
  /// user clicks on the back button, it pops the current context.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  ///
  /// Returns:
  /// A `Scaffold` widget with a `cardWidget` as its body. The `cardWidget`
  /// contains the title, icon, text, text field and button. The `cardWidget`
  /// also has an action which is a `Row` widget with a `Text` widget and a
  /// `TextButton` widget. The `Text` widget shows the text 'Back to Sign in
  /// Screen' and the `TextButton` widget shows the text 'Sign In' and its
  /// onPressed callback is set to pop the current context.
  Widget build(BuildContext context) {
    double scHeight = MediaQuery.sizeOf(context).height;
    double scWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: cardWidget(
          scHeight: scHeight,
          scWidth: scWidth,
          child: Column(
            children: [
              titleText('Reset Your Passsword'),
              const SizedBox(height: 10),
              const Icon(
                Icons.person,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                maxLines: 2,
                textAlign: TextAlign.center,
                'Please Enter Your Email ID to reset your password',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 20),
              textFieldWidget(
                  hintText: 'Email ID',
                  focusNode: _emailFocusNode,
                  textInputType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                  controller: _emailIdController),
              const SizedBox(
                height: 20,
              ),
              authButton(
                  scWidth: scWidth,
                  text: 'Send Email',
                  onPressed: () {
                    if (_emailIdController.text.isNotEmpty &&
                        EmailValidator.validate(_emailIdController.text)) {
                      _sendResetEmail(_emailIdController.text);
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          action: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Back to Sign in Screen',
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.redAccent),
                  ))
            ],
          )),
    );
  }
}
