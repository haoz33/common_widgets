import 'package:flutter/material.dart';

/// A text widget with trailing icon.
/// The default icon size is 18, this can be changed use the size property within the Icon Widget.
class IconText extends StatelessWidget {
  const IconText({Key? key, required this.text, required this.icon})
      : super(key: key);
  final String text;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: Theme.of(context).textTheme.bodyText1),
          WidgetSpan(
              child: Icon(
            icon.icon,
            size: icon.size ?? 18,
            color: icon.color,
            semanticLabel: icon.semanticLabel,
            key: icon.key,
            textDirection: icon.textDirection,
          )),
        ],
      ),
    );
  }
}
