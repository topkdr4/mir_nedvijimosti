import 'dart:core';

import 'package:app/pages/login/login.dart';
import 'package:app/pages/main/main.dart';
import 'package:flutter/material.dart';

class Router {
    static final Map<String, RouteHolder> routeMap = {
        '/': LoginRoute(),
        '/main': MainRoute()
    };


    static Route<dynamic> getPage(RouteSettings settings) {
        return routeMap[settings.name].build(settings);
    }

}


abstract class RouteHolder {
    String path;

    RouteHolder(this.path);

    PageRouteBuilder build(RouteSettings settings);
}


class LoginRoute extends RouteHolder {

    LoginRoute() : super('/');

    @override
    PageRouteBuilder build(RouteSettings settings) {
        return PageRouteBuilder(
            pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                return LoginPage();
            }
        );
    }

}



class MainRoute extends RouteHolder {

    MainRoute() : super('/main');

    @override
    PageRouteBuilder build(RouteSettings settings) {
        return PageRouteBuilder(
            pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                return MainPage(settings.arguments);
            }
        );
    }

}