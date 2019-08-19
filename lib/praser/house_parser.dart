import 'package:app/entity/house.dart';
import 'package:app/entity/realtor.dart';
import 'package:app/praser/common.dart';
import 'package:app/praser/cottage.dart';
import 'package:app/praser/land.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';




abstract class HouseParser {
    Element tr;

    HouseParser.protected(this.tr);


    factory HouseParser(Element tr) {
        List<Element> cells = tr.querySelectorAll('td');
        Element part = cells[4];

        switch (part.text) {
            case 'Вторичное жилье':
            case 'Новостройки':
            case 'Коммерческая недвижимость':
            case 'Дачи, сады':
            case 'Аренда - жилая':
            case 'Аренда коммерческая':
                return CommonHouseParser(tr);

            case 'Земельные участки':
                return LandParser(tr);

            case 'Коттеджи, дома, таунхаусы':
                return CottageParser(tr);

            default:
                throw Exception('unsupported type ${part.text}');
        }
    }


    @protected
    String getStatus () {
        Element cellStatus = tr.getElementsByTagName('td')[0];
        return cellStatus.text;
    }


    @protected
    int getId() {
        String houseId = tr.attributes['id'];
        return int.parse(houseId);
    }


    @protected
    String getType() {
        Element cells = tr.querySelectorAll('td')[4];
        return cells.text;
    }


    @protected
    int getPrice() {
        Element cellInfo = tr.getElementsByTagName('td')[5];
        Element strong = cellInfo.getElementsByTagName('strong')[0];
        String price = strong.text.replaceAll('руб', '').replaceAll(' ', '');
        return int.parse(price);
    }


    @protected
    String getAddress() {
        Element cellInfo = tr.getElementsByTagName('td')[5];
        Element a = cellInfo.getElementsByTagName('a')[0];
        return a.text;
    }


    @protected
    Realtor getRealtor() {
        Element cellInfo = tr.getElementsByTagName('td')[5];
        Element select = cellInfo.getElementsByTagName('select')[0];
        List<Element> options = select.getElementsByTagName('option');

        for (int i = 0; i < options.length; i++) {
            Element opt = options[i];
            dynamic selected = opt.attributes['selected'];
            if (selected == null)
                continue;

            String name = opt.text;
            String id = opt.attributes['value'];

            return Realtor(id: id, name: name);
        }

        return null;
    }


    @protected
    void parseInfo();


    @protected
    House build();
}