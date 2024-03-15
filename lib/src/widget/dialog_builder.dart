import 'package:flutter/material.dart';

class DialogBuilder {
  static dialogBuild({
    required BuildContext context,
    required String text,
    required bool needOneButton,
    Function? move,
  }) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(text),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Colors.amber,
              ),
              onPressed: () {
                if (move == null) {
                  Navigator.of(context).pop();
                } else {
                  move();
                }
              },
              child: const Text('확인'),
            ),
            needOneButton
                ? const SizedBox()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
          ],
        );
      },
    );
  }
}
