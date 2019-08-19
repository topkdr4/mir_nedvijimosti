import 'dart:io';

import 'package:app/dialogs/error.dart';
import 'package:app/dialogs/loading.dart';
import 'package:app/encoding/ms1251.dart';
import 'package:app/entity/user.dart';
import 'package:app/http/client.dart';
import 'package:app/praser/parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';




class LoginPage extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => LoginPageState();
}


class LoginPageState extends State<LoginPage> {
    static final Uri manageUri = Uri.parse('https://www.mirnedvijimosti.ru/manage/');


    BuildContext context;
    HttpClient client;
    Dio dio;



    @override
    Widget build(BuildContext context) {
        this.context = context;
        return Scaffold(
                body: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Padding(
                            padding: const EdgeInsets.only(
                                    left:  32,
                                    right: 32
                            ),
                            child: renderForm()
                    ),
                ),
            );
    }


    @override
    void initState() {
        super.initState();
        Future.delayed(Duration.zero,() async {
            Loading.show(context);
            HttpClient futureClient = await HttpClient.create();
            onClientReady(futureClient);
        });
    }


    void onClientReady(HttpClient client) async {
        this.client = client;
        this.dio = client.client;

        List<Cookie> cookies = client.cookieJar.loadForRequest(manageUri);
        Cookie session;

        for (int i = 0; i < cookies.length; i++) {
            Cookie cookie = cookies[i];
            if (cookie.name == 'PHPSESSID') {
                session = cookie;
                break;
            }
        }

        if (session == null) {
            Navigator.of(context).pop();
            return;
        }

        User user = await client.validSession();

        if (user.valid) {
            Navigator.of(context).pop();
            moveNext(user);
        } else {
            Navigator.of(context).pop();
        }
    }


    Widget renderForm() {
        return Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                title(),
                loginInput(),
                passwordInput(),
                loginButton()
            ],
        );
    }


    Widget title() {
        return Container(
            margin: EdgeInsets.only(
                bottom: 32
            ),
            child: Text(
                'Мир недвижимости',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 32
                ),
            )
        );
    }


    final TextEditingController loginController = TextEditingController(text: '');
    final TextEditingController passwController = TextEditingController(text: '');


    Widget loginInput() {
        return Container(
            child: TextFormField(
                controller: loginController,
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Логин',
                )
            )
        );
    }


    Widget passwordInput() {
        return Container(
            child: TextFormField(
                controller: passwController,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Пароль',
                ),
                obscureText: true
            )
        );
    }


    Widget loginButton() {
        return Container(
            child: RaisedButton(
                onPressed: this.auth,
                child: Text('Войти'),
            ),
        );
    }


    void moveNext(User user) {
        Navigator
            .of(context)
            .pushNamedAndRemoveUntil(
                '/main',
                (Route<dynamic> route) => false,
                arguments: user
            );
    }


    static final String enter = '%C2%F5%EE%E4';


    void auth() async {
        String login = loginController.text;
        String password = passwController.text;

        FormData formData = FormData.from({
            'login': login,
            'password': password,
            'enter': enter
        });

        Loading.show(context);

        try {
            Response<List<int>> response = await dio.request<List<int>>(
                '/manage/',
                data: formData,
                options: Options(
                    responseType: ResponseType.bytes,
                    method: 'POST'
                )
            );

            String result = MS1251.decode(response.data);
            ParserHtml parser = ParserHtml(result);

            Navigator.of(context).pop();

            if (parser.isLoginForm())
                await ErrorDialog.show(context, 'Неверный логин или пароль');
        } on DioError catch (e) {
            if(e.response != null) {
                String resp = MS1251.decode(e.response.data);

                ParserHtml parser = ParserHtml(resp);

                if (parser.isLoginForm()) {
                    Navigator.of(context).pop();
                    await ErrorDialog.show(context, 'Неверный логин или пароль');
                } else {
                    User user = await this.client.validSession();
                    Navigator.of(context).pop();
                    moveNext(user);
                }
            } else{
                Navigator.of(context).pop();
                await ErrorDialog.show(context, 'Неверный логин или пароль');
            }
        }
    }

}
