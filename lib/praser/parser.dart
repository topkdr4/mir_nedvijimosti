import 'package:app/entity/house.dart';
import 'package:app/praser/house_parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;



class ParserHtml {
    Document document;
    String _original;

    ParserHtml(String html) {
        this._original = html;
        this.document = parse(html);
    }


    bool isLoginForm() {
        Element element = document.getElementById('loginform');
        getUserName();
        return element != null;
    }
    
    
    String getUserName() {
        Element element = document.querySelector('.autor');
        if (element == null)
            return null;

        return element.firstChild.text.trim().replaceAll('Здравствуйте,', '');
    }


    List<int> getAvailablePages() {
        List<Element> pages = document.getElementById('paging').querySelectorAll('a');

        List<int> result = [];

        for (int i = 0; i < pages.length; i++) {
            Element a = pages[i];
            try {
                int page = int.parse(a.text);
                result.add(page);
            } on Exception catch (e) {
                continue;
            }
        }

        return result;
    }


    int getTotal() {
        this.document = parse(_original);
        Element content = document.querySelector('#content');

        String total;

        while (content.hasChildNodes()) {
            Node node = content.firstChild.remove();

            String text = node.text;
            if (text.contains('Всего записей')) {
                total = text;
                break;
            }
        }

        this.document = parse(_original);

        String itemsCount = total.trim().replaceAll('Всего записей: ', '');

        return int.parse(itemsCount);
    }


    int getCurrentPage() {
        String currentPage = document.getElementById('paging').getElementsByTagName("span")[0].text;
        return int.parse(currentPage);
    }



    List<House> getHouses() {
        List<House> result = [];


        Element table = document.querySelector('.table-content');
        List<Element> rows = table.getElementsByTagName('tr');

        for (int i = 1; i < rows.length; i++) {
            Element row = rows[i];

            HouseParser parser = HouseParser(row);
            result.add(parser.build());

            /*String houseId = row.attributes['id'];
            print('houseId: $houseId');

            List<Element> cells = row.querySelectorAll('td');
            Element part = cells[4];
            print('part: ${part.text}');

            Element info = cells[5];

            Element a = info.getElementsByTagName('a')[0];
            String adress = a.text;
            print('address: $adress');

            Element strong = info.getElementsByTagName('strong')[0];
            String price = strong.text.replaceAll('руб', '').replaceAll(' ', '');
            print('price: $price');
*/


            print('-------');
        }

        return result;
    }

}