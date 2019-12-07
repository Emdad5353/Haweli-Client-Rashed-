class OrderModel {
  List<Map> foodItem;
  List<Map> subFoodItem;
  Map<String, dynamic> address;
  double finalTotal;
  double deliveryCost;
  String postcode;
  String location;

  OrderModel(this.foodItem, this.subFoodItem, this.address, this.finalTotal,
      this.deliveryCost, this.postcode, this.location);

  Map<String, dynamic> toJson() {
    return {
      "foodItem": (this.foodItem),
      "subFoodItem": (this.subFoodItem),
      "address": this.address,
      "finalTotal": this.finalTotal,
      "deliveryCost": this.deliveryCost,
      "postcode": this.postcode,
      "location": this.location,
    };
  }

  @override
  String toString() {
    return 'OrderModel{foodItem: $foodItem, subFoodItem: $subFoodItem, address: $address, finalTotal: $finalTotal, deliverCoast: $deliveryCost, postcode: $postcode, location: $location}';
  }
}
