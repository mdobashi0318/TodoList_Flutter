import 'package:flutter/material.dart';

mixin CommonDialog {
  /// SnackBarを表示する
  void displaySnackBar(BuildContext context, String error) {
    SnackBar snackBar = SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// 1つのボタンを表示するダイアログを表示する
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



  /// 2つのボタンを表示するダイアログを表示する
  Future<void> showConfirmAlert(BuildContext context, String title, String leftBtn, Function() leftAction, String rigthBth, Function() rigthAction,) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            SimpleDialogOption(
              child: Text(leftBtn),
              onPressed: leftAction,
            ),
            SimpleDialogOption(
              child: Text(rigthBth),
              onPressed: rigthAction,
            ),
          ],
        );
      },
    );
  }

}
