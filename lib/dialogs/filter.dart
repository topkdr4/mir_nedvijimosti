import 'package:flutter/material.dart';

class HouseFilter extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => HouseFilterState();
}



class HouseFilterState extends State<HouseFilter> {
    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            title: Text('Фильтр недвижимости'),
            actions: [
                FlatButton(
                    child: Text('Применить'),
                    onPressed: () { /* ... */ },
                ),
                FlatButton(
                    child: Text('Отмена'),
                    onPressed: () { /* ... */ },
                )
            ],
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Form(
                        child: Column(
                            children: [
                                typeFilter(),
                                realorFilter()
                            ]
                        )
                    )
                ],
            )
        );
    }


    Widget typeFilter() {
        return FormField(
            builder: (FormFieldState state) {
                return InputDecorator(
                    decoration: InputDecoration(
                        labelText: 'Раздел',
                    ),
                    child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                            isDense: true,
                            onChanged: (String newValue) {},
                            items: null
                        ),
                    ),
                );
            },
        );
    }

    Widget realorFilter() {
        return FormField(
            builder: (FormFieldState state) {
                return InputDecorator(
                    decoration: InputDecoration(
                        labelText: 'Риелтор',
                    ),
                    child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                            isDense: true,
                            onChanged: (String newValue) {},
                            items: null
                        ),
                    ),
                );
            },
        );
    }
}