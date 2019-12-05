import 'package:haweli/DBModels/models/Modifiers.dart';

class Foods {
  final String name;
  int id;
  List<Modifiers> modifiers;
  final String foodId;
  final double price;
  final int qty;
  final double discount;

  Foods(this.name, this.foodId, this.price, this.qty, this.discount);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'foodId': foodId,
      'price': price,
      'qty': qty,
      'discount': discount
    };
  }

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(json["name"], json["foodId"], double.parse(json["price"]),
        int.parse(json["qty"]), double.parse(json["discount"]));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'foodId': foodId,
        'price': price,
        'qty': qty,
        'discount': discount,
        'modifiers': modifiers
      };

  @override
  String toString() {
    return 'Foods{name: $name, foodId: $foodId, price: $price, qty: $qty, discount: $discount, modifier: $modifiers}';
  }
}
