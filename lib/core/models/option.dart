import '../../ui/utils/labels.dart';

class Option {
  final String amount;
  final double price;
  final double salePrice;
  final String unit;
  final String barcode;
  final String location;
  int quantity;

  Option({
    required this.amount,
    required this.price,
    required this.salePrice,
    required this.unit,
    required this.barcode,
    required this.location,
    required this.quantity,
  });

  Option copyWith({
    String? amount,
    double? price,
    double? salePrice,
    String? unit,
    String? barcode,
    String? location,
    int? quantity,
  }) {
    return Option(
      amount: amount ?? this.amount,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      unit: unit ?? this.unit,
      barcode: barcode ?? this.barcode,
      location: location ?? this.location,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'price': price,
      'salePrice': salePrice,
      'unit': unit,
      'barcode': barcode,
      'location': location,
      'quantity': quantity,
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
      barcode: map['barcode'],
      location: map['location'],
      quantity: map['quantity'],
    );
  }

    void increment(int value){
     quantity = quantity + value;
  }
}
