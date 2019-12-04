class Modifiers {
  final String name;
  final String subFoodId;
  final String foodId;
  final String modifierId;
  final double price;
  final int qty;

  Modifiers(this.name, this.subFoodId, this.foodId, this.price, this.qty,
      this.modifierId);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodId': subFoodId,
      'subFoodId': foodId,
      'price': price,
      'qty': qty,
      'modifierId': modifierId
    };
  }

  @override
  String toString() {
    return 'name: $name, subFoodId: $subFoodId, foodId: $foodId, modifierId: $modifierId, price: $price, qty: $qty}';
  }
}
