import 'package:app/entity/house.dart';
import 'package:flutter/material.dart';


class CottageHouse extends House {



    Widget buildView() {
        return Card(
                child: ListTile(
                    title: Text(address),
                )
        );
    }
}