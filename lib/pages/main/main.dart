import 'package:app/database/Catalog.dart';
import 'package:app/dialogs/filter.dart';
import 'package:app/dialogs/loading.dart';
import 'package:app/entity/house.dart';
import 'package:app/entity/user.dart';
import 'package:app/http/client.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
    User user;

    MainPage(this.user) : super();

    @override
    State<StatefulWidget> createState() => MainPageState(user);
}


class MainPageState extends State<MainPage> {
    User user;
    BuildContext context;

    MainPageState(this.user) : super();


    List<House> items = [];

    int i = 0;

    @override
    Widget build(BuildContext context) {
        this.context = context;
        return Scaffold(
            appBar: AppBar(
                title: Text("Мир недвижимости"),
                actions: [
                    IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () => showDialog(
                            context: context,
                            child: HouseFilter()
                        )
                    ),
                ],
            ),
            drawer: Drawer(
                child: createDrawer()
            ),
            body: Padding(
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () => {

                            },
                            child: items[index].buildView()
                        );
                    },
                ),
            )
        );
    }



    ListView createDrawer() {
        return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
                DrawerHeader(
                    padding: const EdgeInsets.all(16.0),
                    child: UserAccountsDrawerHeader(
                        accountName: Text(
                            user.name,
                            style: TextStyle(
                                color: Colors.black
                            )
                        ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue[500]
                    )
                ),
                ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Синхронизировать каталог'),
                    onTap: () async {
                        Loading.show(context);
                        List<House> data = await Catalog.synchronize();
                        print(data.length);
                        setState(() => {
                            items = data
                        });
                        Navigator.pop(context);
                    },
                ),
                ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Выйти'),
                    onTap: () async {
                        HttpClient client = await HttpClient.create();
                        client.cookieJar.deleteAll();
                        Navigator.pushReplacementNamed(context, '/');
                    },
                ),
            ],
        );
    }

}