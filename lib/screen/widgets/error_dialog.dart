import 'package:flutter/material.dart';

mixin ErrorDialog {
  /// SnackBarを表示する
  void errorSnackBar(BuildContext context, String error) {
    SnackBar snackBar = SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 未入力があったときににダイアログを表示させる
  Future<void> showAlert(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(title),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text("閉じる"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
