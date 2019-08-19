import 'package:app/entity/cottage.dart';
import 'package:app/entity/house.dart';
import 'package:app/praser/house_parser.dart';
import 'package:html/dom.dart';



class CottageParser extends HouseParser {
    CottageParser(Element tr) : super.protected(tr);

    @override
    void parseInfo() {

    }


    @override
    House build() {
        House result = CottageHouse();
        result.address = getAddress();
        return result;
    }

}
