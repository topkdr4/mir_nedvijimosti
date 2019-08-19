import 'package:app/entity/house.dart';
import 'package:app/entity/land.dart';
import 'package:app/praser/house_parser.dart';
import 'package:html/dom.dart';



class LandParser extends HouseParser {
    LandParser(Element tr) : super.protected(tr);

    @override
    void parseInfo() {

    }


    @override
    House build() {
        House result = LandHouse();
        result.address = getAddress();
        return result;
    }

}
