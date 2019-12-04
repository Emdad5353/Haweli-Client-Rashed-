class SubFoods {
  final int id;
  final String name;
  final int subFoodId;
  final double price;
  final int qty;
  final double discount;

  SubFoods(this.id , this.name , this.subFoodId , this.price , this.qty ,
      this.discount);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'foodId': subFoodId,
      'price': price,
      'qty':qty,
      'discount':discount
    };
  }

  @override
  String toString() {
    return 'Foods{id: $id, name: $name, foodId: $subFoodId, price: $price, qty: $qty, discount: $discount}';
  }


}