class Modifiers {
  final String name;
  final int foodId;
  final String modifierId;
  final double price;
  final int qty;

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

  @override
  String toString() {
    return 'name: $name, foodId: $foodId, modifierId: $modifierId, price: $price, qty: $qty}';
  }
}
