class FoodItemModel {
  String foodItemId;
  List<String> modifiers;
  int qty;

  FoodItemModel(this.foodItemId, this.modifiers, this.qty);

  String get foodId => this.foodItemId;
  int get qtyVal => this.qtyVal;
  List<String> get modifiersArr => this.modifiers;

  Map<String, dynamic> toJson() {
    return {
      "foodItemId": this.foodItemId,
      "modifiers": this.modifiers,
      "qty": this.qty,
    };
  }

  Map<String, dynamic> toMap() {
    return {"foodItemId": foodItemId, "modifiers": modifiers, "qty": qty};
  }

  @override
  String toString() {
    return 'FoodItemModel{foodItemId: $foodItemId, modifiers: $modifiers, qty: $qty}';
  }
}
