import 'package:flutter/material.dart';


class Loading {


    static Future<void> show(BuildContext context) {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext c) {
                return WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: Dialog(
                        child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    CircularProgressIndicator(),
                                    Padding(
                                        padding: EdgeInsets.only(left: 32),
                                        child: Text(
                                            'Загрузка',
                                            style: TextStyle(
                                                   fontSize: 16
                                            ),
                                        ),
                                    )
                                 ],
                            )
                        ),
                    ),
                );
            }
        );
    }
}