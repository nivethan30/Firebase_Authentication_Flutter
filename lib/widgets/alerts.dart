import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
export 'package:quickalert/models/quickalert_type.dart';
import '../utils/constants.dart';

/// Displays a QuickAlert dialog with the specified title, text, and alert type.
/// 
/// The dialog is shown using the current navigator context. If the context is
/// unavailable, a debug message is printed.
/// 
/// Parameters:
/// - `title`: The title of the alert dialog.
/// - `text`: The main message or body text of the alert dialog.
/// - `type`: The type of alert to display, defaults to `QuickAlertType.success`.
/// 
/// The alert dialog features a customizable background color, title, and text
/// alignment, as well as color configurations for the title, text, and confirm
/// button.
void alertWidget(
    {required String title,
    required String text,
    QuickAlertType type = QuickAlertType.success}) {
  final context = navigatorkey.currentContext;
  if (context != null) {
    QuickAlert.show(
        backgroundColor: const Color.fromARGB(255, 28, 10, 109),
        context: context,
        type: type,
        title: title,
        titleAlignment: TextAlign.center,
        text: text,
        textAlignment: TextAlign.center,
        titleColor: Colors.white,
        textColor: Colors.white,
        confirmBtnColor: Colors.white,
        confirmBtnTextStyle: const TextStyle(color: Colors.black));
  } else {
    debugPrint('Navigator context is not available.');
  }
}
