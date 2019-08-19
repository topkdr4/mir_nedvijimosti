import 'package:flutter/material.dart';

class ErrorDialog {

    static Future<void> show(BuildContext context, String message) {
        return showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Ошибка'),
                    content: Text(message),
                    actions: [
                        FlatButton(
                            child: Text('ОК'),
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