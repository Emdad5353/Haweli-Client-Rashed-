class OrderModel {
  List<Map> foodItem;
  List<Map> subFoodItem;
  Map<String, dynamic> address;
  double finalTotal;
  double deliveryCost;
  String postcode;
  bool deliveryStatus;
  bool collectionStatus;
  bool isDiscountAdded;
  String discountType;
  double discountAmount;


  OrderModel(this.foodItem , this.subFoodItem , this.address , this.finalTotal ,
      this.deliveryCost , this.deliveryStatus ,
      this.collectionStatus , this.isDiscountAdded , this.discountType ,
      this.discountAmount);

  Map<String , dynamic> toJson() {
    return {
      "foodItem": (this.foodItem) ,
      "subFoodItem": (this.subFoodItem) ,
      "address": this.address ,
      "finalTotal": this.finalTotal ,
      "deliveryCost": this.deliveryCost ,
      "deliveryStatus": this.deliveryStatus ,
      "collectionStatus": this.collectionStatus,
      "isDiscountAdded": this.isDiscountAdded,
      "discountType": this.discountType,
      "discountAmount": this.discountAmount,
    };
  }

  @override
  String toString() {
    return 'OrderModel{foodItem: $foodItem, subFoodItem: $subFoodItem, address: $address, finalTotal: $finalTotal, deliveryCost: $deliveryCost, postcode: $postcode, isDiscountAdded: $isDiscountAdded, discountType: $discountType, discountAmount: $discountAmount, deliveryStatus: $deliveryStatus, collectionStatus: $collectionStatus}';
  }


//  OrderModel(
//      this.foodItem,
//      this.subFoodItem,
//      this.address,
//      this.finalTotal,
//      this.deliveryCost,
//      this.deliveryStatus,
//      this.collectionStatus);
//

//
//  @override
//  String toString() {
//    return 'OrderModel{foodItem: $foodItem, subFoodItem: $subFoodItem, '
//        'address: $address, finalTotal: $finalTotal, deliveryCost: $deliveryCost, '
//        'postCode: $postcode,  deliveryStatus: $deliveryStatus, '
//        'collectionStatus: $collectionStatus}';
//  }
}
