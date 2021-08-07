import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';


//トップレベル関数
showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required ValueChanged onConfirmed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,//ボタン以外押せなくなる
    builder: (_) => ConfirmDialog(
      title: title,
      content: content,
      onConfirmed: onConfirmed,
    ),
  );
}

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final ValueChanged<bool>? onConfirmed;//bool型として持って引数を持たせる

  ConfirmDialog({this.title, this.content, this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title!),
      content: Text(content!),
      actions: [
        TextButton(
          child: Text(S.of(context).yes),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed!(true);
          },
        ),
        TextButton(
          child: Text(S.of(context).no),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed!(false);
          },
        ),
      ],
    );
  }
}
