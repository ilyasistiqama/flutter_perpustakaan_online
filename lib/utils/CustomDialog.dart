// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomDialog {
  static Future getDialogOnly(
      {required String title,
      required String message,
      required BuildContext context}) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );

    return showDialog(context: context, builder: (context) => alert);
  }

  static Future getDialogCameBackTwice(
      {required String title,
      required String message,
      required BuildContext context}) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );

    return showDialog(context: context, builder: (context) => alert);
  }

  static Future getDialogCameBackThreeTimes(
      {required String title,
      required String message,
      required BuildContext context}) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );

    return showDialog(context: context, builder: (context) => alert);
  }

  static Future getDialogWithPushReplacement(
      {required String title,
      required String message,
      required BuildContext context,
      dynamic classView}) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => classView),
            );
          },
        ),
      ],
    );

    return showDialog(context: context, builder: (context) => alert);
  }
}