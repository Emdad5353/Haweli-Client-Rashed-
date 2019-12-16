class OrderModel {
  List<Map> foodItem;
  List<Map> subFoodItem;
  Map<String, dynamic> address;
  double finalTotal;
  double deliveryCost;
  String postcode;
  String location;
  bool deliveryStatus;
  bool collectionStatus;

  OrderModel(
      this.foodItem,
      this.subFoodItem,
      this.address,
      this.finalTotal,
      this.deliveryCost,
      this.postcode,
      this.location,
      this.deliveryStatus,
      this.collectionStatus);

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
    return 'OrderModel{foodItem: $foodItem, subFoodItem: $subFoodItem, '
        'address: $address, finalTotal: $finalTotal, deliveryCost: $deliveryCost, '
        'postcode: $postcode, location: $location, deliveryStatus: $deliveryStatus, '
        'collectionStatus: $collectionStatus}';
  }
}
