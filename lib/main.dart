import 'package:app/routing/router.dart';
import 'package:flutter/material.dart';


void main() async {
    runApp(new MyApp());
}

class MyApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: ThemeData(
                primarySwatch: Colors.blue[80],
                textTheme: TextTheme(
                    body1: TextStyle(
                        fontSize: 16
                    )
                )
            ),
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
                return Router.getPage(settings);
            },
            debugShowCheckedModeBanner: false
        );
    }
}