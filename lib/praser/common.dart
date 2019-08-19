import 'package:app/entity/common.dart';
import 'package:app/entity/house.dart';
import 'package:app/praser/house_parser.dart';
import 'package:html/dom.dart';



class CommonHouseParser extends HouseParser {

    final info = _HouseInfo();


    CommonHouseParser(Element tr) : super.protected(tr);

    @override
    void parseInfo() {
        Element cellInfo = tr.getElementsByTagName('td')[5].clone(true);
        List<Element> divs = cellInfo.querySelectorAll('div');
        Element a = cellInfo.querySelector('a');
        Element strong = cellInfo.querySelector('strong');


        for (int i = 0; i < divs.length; i++) {
            Element div = divs[i];
            div.remove();
        }

        a.remove();
        strong.remove();

        String attributes = cellInfo.text.trim();

        RegExp regExp = new RegExp(r"\[(.*?)\]");
        Iterable<Match> matches = regExp.allMatches(attributes);
        List<String> fullInfo = matches.map((key) => key.group(1)).toList();

        for (int i = 0; i < fullInfo.length; i++) {
            String data = fullInfo[i];
            if (data.contains('комн.')) {
                info.rooms = int.parse(data.replaceAll('комн.', '').trim());
            } else if (data.contains('эт.')) {
                List<String> floor = data.replaceAll('эт.', '').trim().split('/');
                info.current = int.parse(floor[0]);
                info.all = int.parse(floor[1]);
            } else if (data.contains('м2')) {
                String squareStr = data.replaceAll('м2', '').trim();
                info.square = double.parse(squareStr);
            } else {
                info.others.add(data);
            }
        }

    }


    @override
    House build() {
        parseInfo();

        CommonHouse result = CommonHouse();
        result.id = getId();
        result.address = getAddress();
        result.price = getPrice();
        result.status = getStatus();
        result.allFloor = info.all;
        result.rooms = info.rooms;
        result.currentFloor = info.current;
        result.square = info.square;
        result.othersAttrs.addAll(info.others);
        result.realtor = getRealtor();

        return result;
    }

}


class _HouseInfo {
    int rooms;
    int all;
    int current;
    double square;
    List<String> others = [];
}