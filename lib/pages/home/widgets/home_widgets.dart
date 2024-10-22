import 'package:flutter/material.dart';

class TitleValueRow extends StatelessWidget {
  final String title;
  final String value;
  const TitleValueRow({super.key, required this.title, required this.value});

  @override
  /// A Row with two Expanded widgets. The first contains the [title] as a bold
  /// text and the second contains the [value] as a regular text.
  ///
  /// The two widgets are spaced evenly and at the start of the row. The
  /// crossAxisAlignment is set to [CrossAxisAlignment.start], which means the
  /// widgets are aligned to the start of the row.
  ///
  /// The whole row is padded with 10 vertical pixels.
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(
              flex: 2,
              child: Text(
                value,
              )),
        ],
      ),
    );
  }
}

  /// A purple ElevatedButton with a white text and an icon, with a fixed size
  /// that depends on the screen width.
  ///
  /// If the screen width is greater than 500, the size is 300x50, otherwise it's
  /// the screen width divided by 1.5, which is the recommended size for a
  /// button on a mobile device.
  ///
  /// The button has a circular border with a radius of 10.
  ///
  /// The [text] parameter is the text that is displayed on the button.
  ///
  /// The [iconData] parameter is the icon that is displayed on the button.
  ///
  /// The [onPressed] parameter is the callback that is called when the button is
  /// pressed.
Widget homeButtons(double scWidth,
    {required String text,
    required IconData iconData,
    required VoidCallback onPressed}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
        fixedSize: scWidth > 500 ? Size(300, 50) : Size(scWidth / 1.5, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white),
    onPressed: onPressed,
    label: Text(text),
    icon: Icon(iconData),
  );
}
