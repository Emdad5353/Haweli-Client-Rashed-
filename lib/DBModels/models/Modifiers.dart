class Modifier {
  final int id;
  final String name;
  final int subFoodId;
  final int foodId;
  final int modifierId;
  final double price;
  final int qty;
  final double discount;

  Modifier(this.id, this.name, this.subFoodId, this.foodId, this.price,
      this.qty, this.discount, this.modifierId);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodId': subFoodId,
      'subFoodId': foodId,
      'price': price,
      'qty': qty,
      'modifierId': modifierId,
      'discount': discount
    };
  }

  @override
  String toString() {
    return 'Modifier{id: $id, name: $name, subFoodId: $subFoodId, foodId: $foodId, modifierId: $modifierId, price: $price, qty: $qty, discount: $discount}';
  }
}
