import 'package:app/entity/house.dart';
import 'package:flutter/material.dart';



class CommonHouse extends House {

    /// Этаж
    int currentFloor;

    /// Всего этажей
    int allFloor;

    /// Комнат
    int rooms;

    @override
    Widget buildView() {
        return Card(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: Text('$id – $address', textAlign: TextAlign.left),
                                ),
                                ButtonTheme.bar(
                                    child: ButtonBar(
                                        children: [
                                            FlatButton(
                                                child: Text('подробнее'),
                                                onPressed: () { /* ... */ },
                                            ),
                                        ],
                                    ),
                                )
                            ],
                        ),
                    )
                ],
            )
        );
    }

}
