import 'package:app/encoding/ms1251.dart';
import 'package:app/entity/house.dart';
import 'package:app/http/client.dart';
import 'package:app/praser/house_parser.dart';
import 'package:app/praser/parser.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Catalog {
    static Database _database;


    static final String CREATE_TABLE = ""
            "create table if not exists house ("
            "id        INTEGER PRIMARY KEY,"
            "address   TEXT NOT NULL,"
            "partition TEXT NOT NULL,"
            "attr      TEXT NOT NULL,"
            "price     TEXT NOT NULL"
            ");";


    static void init () async {
        _database = await openDatabase(
            join(await getDatabasesPath(), 'catalog.db'),
            onCreate: (db, version) {
                return db.execute(CREATE_TABLE);
            },
            version: 1,
        );
    }



    static Future<List<House>> synchronize() async {
        HttpClient client = await HttpClient.create();
        PageFetcher fetcher = PageFetcher(1, client);
        ParserHtml parser = await fetcher.load();
        return parser.getHouses();


        int total = parser.getTotal();
        int pages = (total / 20).ceil();

        /*for (int i = 2; i <= pages; i++) {
            PageFetcher fetcher = PageFetcher(i, client);
            ParserHtml parser = await fetcher.load();
            print('currentPage: ${parser.getCurrentPage()}');
            parser.getHouses();
        }*/
    }

}


class PageFetcher {
    final String url = '/manage/control/contents/?section=14&search_delete_mark=0&page=';
    final int page;
    final HttpClient client;

    PageFetcher(this.page, this.client);


    Future<ParserHtml> load() async {
        try {
            Response<List<int>> response = await client.client.request<List<int>>(
                '$url$page',
                options: Options(
                    responseType: ResponseType.bytes,
                    method: 'GET'
                )
            );

            return ParserHtml(MS1251.decode(response.data));
        } on DioError catch (e) {
            return null;
        }
    }

}