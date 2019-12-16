import 'package:haweli/main.dart';
import 'package:haweli/main_ui.dart';
import 'package:rxdart/rxdart.dart';

class ManageStatesBloc {
  //------------------------------Body View States------------------------------
  BehaviorSubject _currentViewSection = BehaviorSubject.seeded(WidgetMarker.menu);
  Observable get currentViewSectionStream$ => _currentViewSection.stream;

  changeViewSection(WidgetMarker val){
    _currentViewSection.add(val);
  }


  //------------------------------Menu Group States-----------------------------
  BehaviorSubject _currentMenuGroup = BehaviorSubject.seeded('5ddbe0820d7b383f3cf64112');
  Observable get currentMenuGroupStream$ => _currentMenuGroup.stream;

  changeCurrentMenuGroup(String val){
    _currentMenuGroup.add(val);
  }

  //------------------------------Current Login States-----------------------------
  BehaviorSubject _loginStatus = BehaviorSubject.seeded(false);
  Observable get currentLoginStatusStream$ => _loginStatus.stream;

  changeCurrentLoginStatus(bool val){
    _loginStatus.add(val);
  }

//  //------------------------------Delivery Address-----------------------------
//  BehaviorSubject _houseNo = BehaviorSubject.seeded('');
//  Observable get currentHouseNoStream$ => _houseNo.stream;
//  changeCurrentHouseNo(String val){
//    _houseNo.add(val);
//  }
//
//  BehaviorSubject _flatNo = BehaviorSubject.seeded('');
//  Observable get currentFlatNoStream$ => _flatNo.stream;
//  changeCurrentFlatNo(String val){
//    _flatNo.add(val);
//  }
//
//  BehaviorSubject _buildingName = BehaviorSubject.seeded('');
//  Observable get currentBuildingNameStream$ => _buildingName.stream;
//  changeCurrentBuildingName(String val){
//    _buildingName.add(val);
//  }
//
//  BehaviorSubject _roadName = BehaviorSubject.seeded('');
//  Observable get currentRoadNameStream$ => _roadName.stream;
//  changeCurrentRoadName(String val){
//    _roadName.add(val);
//  }
//
//  BehaviorSubject _town = BehaviorSubject.seeded('');
//  Observable get currentTownStream$ => _town.stream;
//  changeCurrentTown(String val){
//    _town.add(val);
//  }
//
//  BehaviorSubject _postCode = BehaviorSubject.seeded('');
//  Observable get currentPostCodeStream$ => _postCode.stream;
//  changeCurrentPostCode(String val){
//    _postCode.add(val);
//  }

}

ManageStatesBloc manageStatesBloc=ManageStatesBloc();