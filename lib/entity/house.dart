import 'package:app/entity/realtor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



abstract class House {

    final currencyFormatter = new NumberFormat("#,##0", "RUB");

    // Идентификатор
    int id;

    /// Цена
    int price;

    /// Прочие атрибуты
    List<String> othersAttrs = [];

    /// Адрес
    String address;

    /// Статус
    String status;

    /// Площадь
    double square;

    /// Риелтор
    Realtor realtor;


    @protected
    String formatPrice() {
        return '${currencyFormatter.format(price)} \u20bd';
    }


    Widget buildView();
}