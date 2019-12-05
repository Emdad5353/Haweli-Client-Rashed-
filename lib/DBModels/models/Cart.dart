class Cart {
  final int foodMainId;
  final String foodName;
  final String foodId;
  final double foodPrice;
  final int foodQty;
  final double foodDiscount;
  final int modifierMainId;
  final String modifiersName;
  final int modifiersFoodId;
  final double modifiersPrice;
  final int modifiersQty;

  Cart(
      this.foodMainId,
      this.foodName,
      this.foodId,
      this.foodPrice,
      this.foodQty,
      this.foodDiscount,
      this.modifierMainId,
      this.modifiersName,
      this.modifiersFoodId,
      this.modifiersPrice,
      this.modifiersQty);

  factory Cart.fromJson(Map<String, dynamic> json) {
    print(json["foodMainId"] is int);
    return Cart(
      json["foodMainId"],
      json["foodName"],
      json["foodId"],
      json["foodPrice"],
      json["foodQty"],
      json["foodDiscount"],
      json["modifierMainId"],
      json["modifiersName"],
      json["modifiersFoodId"],
      json["modifiersPrice"],
      json["modifiersQty"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foodMainId": this.foodMainId,
      "foodName": this.foodName,
      "foodId": this.foodId,
      "foodPrice": this.foodPrice,
      "foodQty": this.foodQty,
      "foodDiscount": this.foodDiscount,
      "modifierMainId": this.modifierMainId,
      "modifiersName": this.modifiersName,
      "modifiersFoodId": this.modifiersFoodId,
      "modifiersPrice": this.modifiersPrice,
      "modifiersQty": this.modifiersQty,
    };
  }

  @override
  String toString() {
    return 'Cart{foodMainId: $foodMainId, foodName: $foodName, foodId: $foodId, foodPrice: $foodPrice, foodQty: $foodQty, foodDiscount: $foodDiscount, modifierMainId: $modifierMainId, modifiersName: $modifiersName, modifiersFoodId: $modifiersFoodId, modifiersPrice: $modifiersPrice, modifiersQty: $modifiersQty}';
  }
}
