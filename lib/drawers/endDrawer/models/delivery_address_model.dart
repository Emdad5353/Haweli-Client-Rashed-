import 'package:flutter/material.dart';

class DeliveryAddress {
  String houseNo;
  String flatNo;
  String buildingName;
  String roadName;
  String town;
  String postCode;

  DeliveryAddress(this.houseNo,this.flatNo,this.buildingName,this.roadName,this.town,this.postCode);
}

class StateContainer extends StatefulWidget {
  final Widget child;
  final DeliveryAddress deliveryAddress;

  StateContainer({
    @required this.child,
    this.deliveryAddress,
  });

  static StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  DeliveryAddress deliveryAddress;

  void updateUserInfo({houseNo,flatNo,buildingName,roadName,town,postCode}) {
    if (deliveryAddress == null) {
      deliveryAddress = DeliveryAddress(houseNo,flatNo,buildingName,roadName,town,postCode);
      setState(() {
        deliveryAddress = deliveryAddress;
      });
    } else {
      setState(() {
        deliveryAddress.houseNo = houseNo ?? deliveryAddress.houseNo;
        deliveryAddress.flatNo = flatNo ?? deliveryAddress.flatNo;
        deliveryAddress.buildingName = buildingName ?? deliveryAddress.buildingName;
        deliveryAddress.roadName = roadName ?? deliveryAddress.roadName;
        deliveryAddress.town = town ?? deliveryAddress.town;
        deliveryAddress.postCode = postCode ?? deliveryAddress.postCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final StateContainerState data;

  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}