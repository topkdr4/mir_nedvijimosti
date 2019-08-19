import 'dart:async';
import 'dart:io';

import 'package:app/encoding/ms1251.dart';
import 'package:app/entity/user.dart';
import 'package:app/praser/parser.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';



class HttpClient extends Dio {
    Dio client;
    PersistCookieJar cookieJar;


    HttpClient(options, cookieJar) {
        this.client = Dio(options);
        this.cookieJar = cookieJar;
        this.client.interceptors.add(CookieManager(cookieJar));
    }


    static Future<HttpClient> create() async {
        Directory dir = await getApplicationDocumentsDirectory();
        print(dir.path);

        BaseOptions options = BaseOptions(
            baseUrl: "https://www.mirnedvijimosti.ru",
            connectTimeout: 60000,
            receiveTimeout: 60000,
        );

        PersistCookieJar cookieJar = PersistCookieJar(
            dir:dir.path,
            ignoreExpires: true
        );

        HttpClient result = HttpClient(options, cookieJar);

        return result;
    }


    Future<User> validSession() async {
        try {
            Response<List<int>> response = await client.request<List<int>>(
                '/manage/control/contents/?section=14&search_delete_mark=0&page=1',
                options: Options(
                    responseType: ResponseType.bytes,
                    method: 'GET'
                )
            );

            String resp = MS1251.decode(response.data);
            ParserHtml parser = ParserHtml(resp);

            User result = User();
            result.valid = !parser.isLoginForm() == true;

            if (result.valid) {
                result.name = parser.getUserName();
                return result;
            }

            return result;
        } on DioError catch (e) {
            User result = User();

            if(e.response != null) {
                String resp = MS1251.decode(e.response.data);
                ParserHtml parser = ParserHtml(resp);

                result.valid = !parser.isLoginForm() == true;

                if (result.valid) {
                    return result;
                }

                result.name = parser.getUserName();
                return result;
            } else{
                result.valid = false;
                return result;
            }
        }
    }

}