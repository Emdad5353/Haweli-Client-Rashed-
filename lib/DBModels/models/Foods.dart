class Foods {
  final int id;
  final String name;
  final int foodId;
  final double price;
  final int qty;
  final double discount;

  Foods(this.id , this.name , this.foodId , this.price , this.qty ,
      this.discount);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodId': foodId,
      'price': price,
      'qty':qty,
      'discount':discount
    };
  }

  @override
  String toString() {
    return 'Foods{id: $id, name: $name, foodId: $foodId, price: $price, qty: $qty, discount: $discount}';
  }


}