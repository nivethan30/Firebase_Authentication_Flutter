import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import '../../widgets/alerts.dart';
import 'widgets/auth_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _userNameFocusNode = FocusNode();

  final AuthService _authService = AuthService();

  bool passwordText = true;
  bool confirmPasswordText = true;

  /// Creates a new user with the given [userName], [email] and [password].
  ///
  /// If the account is created successfully, it pops the context and shows
  /// an alert with a success message.
  Future<void> createAccountWithEmailAndPassword(
      String userName, String email, String password) async {
    final user = await _authService.createUserWithEmailAndPassword(
        userName, email, password);
    if (user != null) {
      _popContext();
      alertWidget(
          title: 'Signup Success',
          text: 'Your Account Has Been Created Successfully');
    }
  }

  /// Pops the current context and goes back to the previous screen.
  ///
  /// This method is used when the user account is created successfully.
  /// It pops the context and goes back to the login screen.
  void _popContext() {
    Navigator.pop(context);
  }

  @override
/// Disposes of all the controllers and focus nodes used in the SignUpPage.
/// 
/// This method disposes of the following controllers and focus nodes:
/// - _emailIdController: Controller for email input field.
/// - _passwordController: Controller for password input field.
/// - _userNameController: Controller for username input field.
/// - _confirmPasswordController: Controller for confirm password input field.
/// - _emailFocusNode: Focus node for email input field.
/// - _passwordFocusNode: Focus node for password input field.
/// - _confirmPasswordFocusNode: Focus node for confirm password input field.
/// - _userNameFocusNode: Focus node for username input field.
/// 
/// It also calls [super.dispose()] to dispose of other resources.
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _userNameFocusNode.dispose();
    super.dispose();
  }

  @override

  /// Builds the SignUpPage widget.
  ///
  /// This widget shows the user a title, an icon, a text, a text field to enter
  /// the username, a text field to enter the email ID, a text field to enter
  /// the password, a text field to enter the confirm password, a button to sign
  /// up and a button to sign up with Google. If the user clicks on the sign up
  /// button, it calls [createAccountWithEmailAndPassword] with the given
  /// username, email ID and password. If the account is created successfully,
  /// it pops the context and shows an alert with a success message. If the user
  /// clicks on the sign up with Google button, it calls [AuthService.signInWithGoogle]
  /// and if the user is signed in successfully, it pops the context. If the
  /// connection state is waiting, it shows a CircularProgressIndicator, if there
  /// is an error, it shows a Text with the error message.
  ///
  /// The widget also has a back button to go back to the login screen. If the
  /// user clicks on the back button, it pops the context.
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
              titleText('Sign Up to Create an Account'),
              const SizedBox(height: 10),
              const Icon(
                Icons.person,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 10),
              textFieldWidget(
                  hintText: 'UserName',
                  focusNode: _userNameFocusNode,
                  autofillHints: [AutofillHints.name],
                  textInputType: TextInputType.name,
                  controller: _userNameController),
              const SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  hintText: 'Email ID',
                  focusNode: _emailFocusNode,
                  autofillHints: [AutofillHints.email],
                  textInputType: TextInputType.emailAddress,
                  controller: _emailIdController),
              const SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  hintText: 'Password',
                  focusNode: _passwordFocusNode,
                  obscureText: passwordText,
                  controller: _passwordController,
                  textInputType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordText = !passwordText;
                      });
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  hintText: 'Confirm Password',
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: confirmPasswordText,
                  controller: _confirmPasswordController,
                  textInputType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmPasswordText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        confirmPasswordText = !confirmPasswordText;
                      });
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              authButton(
                  scWidth: scWidth,
                  text: 'Sign Up',
                  onPressed: () {
                    _signUpButtonAction();
                  }),
              const SizedBox(
                height: 20,
              ),
              googleButton(
                  scWidth: scWidth,
                  text: 'Sign up With Google',
                  onPressed: () async {
                    final User? user = await _authService.signInWithGoogle();

                    if (user != null) {
                      _popContext();
                    }
                  }),
            ],
          ),
          action: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already Have an Account? ',
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

  /// Creates a new user account with the given user name, email and password.
  ///
  /// Checks if the input fields are not empty and if the email is valid.
  /// If all the conditions are met, it calls [createAccountWithEmailAndPassword]
  /// to create the user account. If the passwords do not match, it shows an
  /// error alert dialog. If any of the input fields are empty, it shows a
  /// snackbar with an error message.
  ///
  Future<void> _signUpButtonAction() async {
    if ((_emailIdController.text.isNotEmpty &&
            EmailValidator.validate(_emailIdController.text)) &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        createAccountWithEmailAndPassword(_userNameController.text,
            _emailIdController.text, _passwordController.text);
      } else {
        alertWidget(
            title: 'Password Mismatch',
            text: 'Password and Confirm Password should be same',
            type: QuickAlertType.error);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        content: Text(
          'Please Fill the fields',
          style: TextStyle(color: Colors.black),
        ),
        action: SnackBarAction(
            textColor: Colors.black,
            label: 'Ok',
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            }),
      ));
    }
  }
}
