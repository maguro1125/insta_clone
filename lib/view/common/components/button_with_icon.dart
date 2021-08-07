import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonWithIcon extends StatelessWidget {
  final IconData? iconData;
  final VoidCallback? onPressed;
  final String? label;
  final Color? color;

  ButtonWithIcon({this.onPressed, this.iconData, this.label,this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(8.0)
    //   ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
        ),
    ),
        backgroundColor: MaterialStateProperty.all<Color?>(
          color
        ),
      ),
      onPressed: onPressed,
      icon: FaIcon(iconData),
      label: Text(label!),
    );
  }
}
