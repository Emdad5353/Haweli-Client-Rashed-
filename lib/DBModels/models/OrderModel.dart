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
  String instructions;
  String preferredTime;


  OrderModel(this.foodItem , this.subFoodItem , this.address , this.finalTotal ,
      this.deliveryCost , this.deliveryStatus ,
      this.collectionStatus , this.isDiscountAdded , this.discountType ,
      this.discountAmount, this.instructions, this.preferredTime);

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
      "instructions": this.instructions,
      "preferredTime": this.preferredTime,
    };
  }

  @override
  String toString() {
    return 'OrderModel{foodItem: $foodItem, subFoodItem: $subFoodItem, address: $address, finalTotal: $finalTotal, deliveryCost: $deliveryCost, postcode: $postcode, deliveryStatus: $deliveryStatus, collectionStatus: $collectionStatus, isDiscountAdded: $isDiscountAdded, discountType: $discountType, discountAmount: $discountAmount, instructions: $instructions, preferredTime: $preferredTime}';
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
