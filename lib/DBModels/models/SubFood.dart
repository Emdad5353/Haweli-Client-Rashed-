class SubFoods {
  final String name;
  final String subFoodId;
  final double price;
  final int qty;
  final double discount;

  SubFoods(this.name, this.subFoodId, this.price, this.qty, this.discount);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subFoodId': subFoodId,
      'price': price,
      'qty': qty,
      'discount': discount
    };
  }

  @override
  String toString() {
    return 'Foods{name: $name, foodId: $subFoodId, price: $price, qty: $qty, discount: $discount}';
  }
}
