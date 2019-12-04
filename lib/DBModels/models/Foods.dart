class Foods {
  final String name;
  final String foodId;
  final double price;
  final int qty;
  final double discount;

  Foods(this.name, this.foodId, this.price, this.qty, this.discount);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodId': foodId,
      'price': price,
      'qty': qty,
      'discount': discount
    };
  }

  @override
  String toString() {
    return 'Foods{name: $name, foodId: $foodId, price: $price, qty: $qty, discount: $discount}';
  }
}
