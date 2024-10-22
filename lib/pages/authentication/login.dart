import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import 'forgot_password.dart';
import 'signup.dart';
import 'widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final AuthService _authService = AuthService();

  bool isObscureText = true;

/// Signs in a user with the provided email and password.
/// 
/// This method attempts to sign in to the application using the given
/// email and password. It utilizes the `AuthService` to perform the
/// authentication. If the sign-in is successful, the user is logged in
/// and can access their account. If it fails, an error is handled
/// within the `AuthService`.
///
/// Parameters:
/// - `email`: The email address of the user attempting to sign in.
/// - `password`: The password associated with the user's email.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  /// Disposes of the resources used by the [_LoginPageState] widget.
  ///
  /// This method is called when the widget is removed from the tree permanently.
  ///
  /// It disposes of the [_emailIdController], [_passwordController],
  /// [_emailFocusNode], and [_passwordFocusNode].
  ///
  /// It also calls [super.dispose] to allow the widget tree to clean up any
  /// resources that the widget itself may have allocated.
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  /// Builds the login page widget.
  ///
  /// This widget shows the user a message telling them to sign in to continue,
  /// a text field to enter their email ID, a text field to enter their password,
  /// a button to sign in, a button to sign in with Google, and a button to
  /// sign up. If the user enters an invalid email ID or password, an error is
  /// displayed. If the user signs in successfully, they are logged in and can
  /// access their account. If the user signs in with Google successfully, they
  /// are logged in and can access their account. If the user signs up successfully,
  /// they are logged in and can access their account.
  Widget build(BuildContext context) {
    double scHeight = MediaQuery.sizeOf(context).height;
    double scWidth = MediaQuery.sizeOf(context).width;
    return cardWidget(
        scHeight: scHeight,
        scWidth: scWidth,
        child: Column(
          children: [
            titleText('Welcome Back. Sign in to continue.'),
            const SizedBox(height: 10),
            const Icon(
              Icons.person,
              color: Colors.white,
              size: 100,
            ),
            const SizedBox(height: 10),
            textFieldWidget(
                hintText: 'Email ID',
                focusNode: _emailFocusNode,
                controller: _emailIdController,
                textInputType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email]),
            const SizedBox(
              height: 20,
            ),
            textFieldWidget(
                hintText: 'Password',
                focusNode: _passwordFocusNode,
                obscureText: isObscureText,
                controller: _passwordController,
                textInputType: TextInputType.visiblePassword,
                autofillHints: [AutofillHints.password],
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscureText = !isObscureText;
                    });
                  },
                )),
            const SizedBox(
              height: 5,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            authButton(
                scWidth: scWidth,
                text: 'Login',
                onPressed: () {
                  if ((_emailIdController.text.isNotEmpty &&
                          EmailValidator.validate(_emailIdController.text)) &&
                      _passwordController.text.isNotEmpty) {
                    signInWithEmailAndPassword(
                        _emailIdController.text, _passwordController.text);
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            googleButton(
                scWidth: scWidth,
                text: 'Sign in With Google',
                onPressed: () async {
                  await _authService.signInWithGoogle();
                }),
          ],
        ),
        action: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Don\'t have an account?',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.redAccent),
                ))
          ],
        ));
  }
}
