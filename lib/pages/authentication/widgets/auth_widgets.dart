import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../../utils/assets.dart';

/// A SizedBox containing a SignInButton for Google sign in.
///
/// The size of the button depends on the screen width. If the screen width is
/// greater than 500, the size is 300x50, otherwise it's the screen width divided
/// by 1.5, which is the recommended size for a button on a mobile device.
///
/// The button has a circular border with a radius of 10.
///
/// The [text] parameter is the text that is displayed on the button.
///
/// The [onPressed] parameter is the callback that is called when the button is
/// pressed.
SizedBox googleButton(
    {required double scWidth,
    required String text,
    required VoidCallback onPressed}) {
  return SizedBox(
    width: scWidth > 500 ? 300 : scWidth / 1.5,
    height: 50,
    child: SignInButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        Buttons.google,
        text: text,
        onPressed: onPressed),
  );
}

/// A white ElevatedButton with a black text and a circular border with a radius
/// of 10.
///
/// The size of the button depends on the screen width. If the screen width is
/// greater than 500, the size is 300x50, otherwise it's the screen width divided
/// by 1.5, which is the recommended size for a button on a mobile device.
///
/// The [text] parameter is the text that is displayed on the button.
///
/// The [onPressed] parameter is the callback that is called when the button is
/// pressed.
ElevatedButton authButton(
    {required double scWidth,
    required String text,
    required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        fixedSize: scWidth > 500 ? Size(300, 50) : Size(scWidth / 1.5, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black),
    child: Text(
      text,
      style: const TextStyle(fontSize: 15),
    ),
  );
}


/// A TextField with a white text and a OutlineInputBorder.
///
/// The [hintText] parameter is the text that is displayed as a hint in the
/// TextField.
///
/// The [focusNode] parameter is the FocusNode that is used to manage the focus
/// of the TextField.
///
/// The [controller] parameter is the TextEditingController that is used to
/// manage the text in the TextField.
///
/// The [suffixIcon] parameter is an optional IconButton that is displayed
/// next to the TextField.
///
/// The [autofillHints] parameter is an optional list of AutofillHints that
/// are used to provide hints to the user about what to enter into the
/// TextField.
///
/// The [textInputType] parameter is an optional TextInputType that is used
/// to determine the type of keyboard that is displayed for the TextField.
///
/// The [obscureText] parameter is an optional parameter that is used to
/// determine whether the text in the TextField should be obscured from view.
/// Defaults to false.
TextField textFieldWidget(
    {required String hintText,
    required FocusNode focusNode,
    required TextEditingController controller,
    IconButton? suffixIcon,
    List<String>? autofillHints,
    TextInputType? textInputType,
    bool obscureText = false}) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    onTapOutside: (event) {
      focusNode.unfocus();
    },
    obscureText: obscureText,
    keyboardType: textInputType,
    style: const TextStyle(color: Colors.white),
    autofillHints: autofillHints,
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: hintText,
        labelStyle: const TextStyle(color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        suffixIcon: suffixIcon),
  );
}

/// Creates a centered, bold, white text widget with a maximum of two lines.
///
/// The [title] parameter specifies the string to display.
/// The text is styled with a font size of 20 and a weight of bold.
Text titleText(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    maxLines: 2,
    style: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  );
}

/// A widget that displays a card with a blurred background and a child widget.
///
/// The card is decorated with a circular border and a color that is
/// semi-transparent. The child widget is centered in the card.
///
/// The [scHeight] and [scWidth] parameters specify the size of the card.
///
/// The [child] parameter is the widget that is displayed inside the card.
///
/// The [action] parameter is an optional widget that is displayed below the
/// card. It can be used to add a call to action to the card.
Widget cardWidget(
    {required double scHeight,
    required double scWidth,
    required Widget child,
    required Widget? action}) {
  return SingleChildScrollView(
    child: Container(
      height: scHeight,
      width: scWidth,
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(Assets.backgroundImage),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
                width: scWidth > 500 ? 500 : scWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200.withOpacity(0.1),
                ),
                margin: const EdgeInsets.all(10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: child),
          ),
          if (action != null) action
        ],
      ),
    ),
  );
}
