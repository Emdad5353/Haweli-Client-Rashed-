class SubFoodItemModel {
  String subFoodItemId;
  List<String> modifiers;
  int qty;

  SubFoodItemModel(this.subFoodItemId, this.modifiers, this.qty);

  Map<String, dynamic> toJson() {
    return {
      "subFoodItemId": this.subFoodItemId,
      "modifiers": this.modifiers,
      "qty": this.qty,
    };
  }

  Map<String, dynamic> toMap() {
    return {"foodItemId": subFoodItemId, "modifiers": modifiers, "qty": qty};
  }
}
