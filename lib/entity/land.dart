import 'package:app/entity/house.dart';
import 'package:flutter/material.dart';



class LandHouse extends House {

    @override
    Widget buildView() {
        return Card(
                child: ListTile(
                    title: Text(address),
                )
        );
    }

}