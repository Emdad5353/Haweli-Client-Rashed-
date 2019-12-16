import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/main_ui.dart';
import 'package:rxdart/rxdart.dart';

class ManageStatesBloc {
  OrderModel orderModel;
  // ignore: close_sinks
  BehaviorSubject<OrderModel> _changeOrderModel = new BehaviorSubject.seeded(
      OrderModel([], [], {}, 0, 0, "", "", false, false));

  setModel(OrderModel orderModel) {
    print("OrderModel==============================> $orderModel");
    _changeOrderModel = new BehaviorSubject.seeded(orderModel);
  }

//  BehaviorSubject _changeOrderModel = BehaviorSubject.seeded(orderModel);
  Observable get currentOrderModel$ => _changeOrderModel.stream;

  changeOrderModel() {
    print(_changeOrderModel.value);
    return _changeOrderModel.value;
  }

  //------------------------------Body View States------------------------------
  BehaviorSubject _currentViewSection =
      BehaviorSubject.seeded(WidgetMarker.menu);
  Observable get currentViewSectionStream$ => _currentViewSection.stream;

  changeViewSection(WidgetMarker val) {
    _currentViewSection.add(val);
  }

  //------------------------------Menu Group States-----------------------------
  BehaviorSubject _currentMenuGroup =
      BehaviorSubject.seeded('5ddbe0820d7b383f3cf64112');
  Observable get currentMenuGroupStream$ => _currentMenuGroup.stream;

  changeCurrentMenuGroup(String val) {
    _currentMenuGroup.add(val);
  }

  //------------------------------Current Login States-----------------------------
  BehaviorSubject _loginStatus = BehaviorSubject.seeded(false);
  Observable get currentLoginStatusStream$ => _loginStatus.stream;

  changeCurrentLoginStatus(bool val) {
    _loginStatus.add(val);
  }

}

ManageStatesBloc manageStatesBloc = ManageStatesBloc();
