class Food {
  final int id;
  final String name;
  final int price;
  final int qty;

  Food({this.id, this.name, this.price, this.qty});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'qty':qty
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $price, price: $qty}';
  }

}

