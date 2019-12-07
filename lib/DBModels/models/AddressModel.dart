class AddressModel {
  String houseNo;
  String flatNo;
  String buildingName;
  String roadNo;
  String town;
  String postCode;

  AddressModel(this.houseNo, this.flatNo, this.buildingName, this.roadNo,
      this.town, this.postCode);

  AddressModel.fromJson(Map<String, dynamic> json) {
    houseNo = json['houseNo'];
    flatNo = json['flatNo'];
    buildingName = json['buildingName'];
    roadNo = json['roadNo'];
    town = json['town'];
    postCode = json['postCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['houseNo'] = this.houseNo;
    data['flatNo'] = this.flatNo;
    data['buildingName'] = this.buildingName;
    data['roadNo'] = this.roadNo;
    data['town'] = this.town;
    data['postCode'] = this.postCode;
    return data;
  }
}
