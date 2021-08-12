

import 'package:milk_man_app/ui/utils/labels.dart';

class Option {
  final String amount;
  final double price;
  final double salePrice;
  final String unit;
  Option({
    required this.amount,
    required this.price,
    required this.salePrice,
    required this.unit,
  });

  Option copyWith({
    String? amount,
    double? price,
    double? salePrice,
    String? unit,
  }) {
    return Option(
      amount: amount ?? this.amount,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'price': price,
      'salePrice': salePrice,
      'unit': unit,
    };
  }

  String get priceLabel => "${Labels.rupee}${price.toInt().toString()}";
  String get salePriceLabel => "${Labels.rupee}${salePrice.toInt().toString()}";
  String get amountLabel => "$amount $unit";

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      amount: map['amount'],
      price: map['price'].toDouble(),
      salePrice: map['salePrice'].toDouble(),
      unit: map['unit'],
    );
  }

}
