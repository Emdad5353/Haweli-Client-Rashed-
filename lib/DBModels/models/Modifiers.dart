class Modifiers {
  final String name;
  final int foodId;
  final String modifierId;
  final double price;
  final int qty;
  int id;

  Modifiers(this.name, this.foodId, this.price, this.qty, this.modifierId);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodId': foodId,
      'price': price,
      'qty': qty,
      'modifierId': modifierId
    };
  }

  Map<String, dynamic> toGetMap() {
    return {
      'id': id,
      'name': name,
      'foodId': foodId,
      'price': price,
      'qty': qty,
      'modifierId': modifierId
    };
  }

  @override
  String toString() {
    return 'id: $id, name: $name, foodId: $foodId, modifierId: $modifierId, price: $price, qty: $qty}';
  }
}
