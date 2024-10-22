import '../../widgets/alerts.dart';
import '../wrapper/wrapper.dart';
import 'package:flutter/material.dart';
import '../../firebase/auth_service.dart';
import 'widgets/auth_widgets.dart';

class UpdatePassword extends StatefulWidget {
  final bool isRequiredUpdate;
  const UpdatePassword({super.key, required this.isRequiredUpdate});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final AuthService _authService = AuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmFocusNode = FocusNode();

  bool passwordText = true;
  bool confirmPasswordText = true;

  User? user;

  @override
  /// This method is called when the widget is inserted into the tree.
  ///
  /// It calls the [initState] method of its superclass and then sets the [user]
  /// variable to the current user of the [_authService].

  void initState() {
    super.initState();
    user = _authService.user;
  }

  @override
  /// Builds the update password widget.
  ///
  /// This widget shows the user a title, a text field to enter the new
  /// password, a text field to enter the confirm password, and a button to
  /// update the password. If the user enters a valid new password and
  /// confirm password, it calls [AuthService.updatePassword] with the given
  /// password. If the password is updated successfully, it pops the current
  /// context and shows an alert dialog with a success message. If the password
  /// update fails, it shows an alert dialog with an error message.
  ///
  /// The widget also has a back button to go back to the previous screen. If
  /// the user clicks on the back button, it pops the current context.
  ///
  /// Parameters:
  /// - `context`: The build context of the widget.
  ///
  /// Returns:
  /// A `Scaffold` widget with a `cardWidget` as its body. The `cardWidget`
  /// contains the title, text fields and button. The `cardWidget` also has an
  /// action which is a `Row` widget with a `Text` widget and a `TextButton`
  /// widget. The `Text` widget shows the text 'Back to Sign in Screen' and the
  /// `TextButton` widget shows the text 'Sign In' and its onPressed callback is
  /// set to pop the current context.
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
        action: null,
        child: Column(
          children: [
            titleText('Reset Your Passsword'),
            SizedBox(height: 20),
            textFieldWidget(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                hintText: 'New Password',
                obscureText: passwordText,
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
            SizedBox(
              height: 20,
            ),
            textFieldWidget(
                controller: _confirmPasswordController,
                focusNode: _confirmFocusNode,
                hintText: 'Confirm Password',
                obscureText: true,
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
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  _updatePassword();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800,
                    foregroundColor: Colors.white,
                    fixedSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('Update Password'))
          ],
        ),
      ),
    );
  }

  /// Updates the user's password if the provided password and confirm password
  /// are equal and not empty. If [widget.isRequiredUpdate] is true, it links the
  /// user's email and password to the account. Otherwise, it simply updates the
  /// user's password. If the update is successful, it reloads the user's data
  /// using [AuthService.reload], navigates to the Wrapper screen using
  /// [_navigateToWrapper], and shows an alert dialog with a success message.
  /// If the fields are empty, it shows a SnackBar with an error message.
  Future<void> _updatePassword() async {
    if (_passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text == _confirmPasswordController.text) {
        bool isLinked = false;
        if (widget.isRequiredUpdate) {
          isLinked = await _authService.linkEmailAndPassword(
              user!.email!, _passwordController.text);
        } else {
          isLinked =
              await _authService.updatePassword(_passwordController.text);
        }
        if (isLinked) {
          await _authService.reload();
          _navigateToWrapper();
          alertWidget(
            title: 'Password Updated',
            text:
                'You can now sign in with either Google or your email/password.',
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Fill the fields')));
    }
  }

// Navigates to the WrapperWidget screen.
// 
// This method replaces the current route with a new route to the WrapperWidget screen.
  void _navigateToWrapper() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WrapperWidget()));
  }
}
