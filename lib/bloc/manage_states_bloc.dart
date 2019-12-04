import 'package:haweli/main.dart';
import 'package:rxdart/rxdart.dart';

class ManageStatesBloc {
  //------------------------------Body View States------------------------------
  BehaviorSubject _currentViewSection = BehaviorSubject.seeded(WidgetMarker.menu);
  Observable get currentViewSectionStream$ => _currentViewSection.stream;

  changeViewSection(WidgetMarker val){
    _currentViewSection.add(val);
  }


  //------------------------------Menu Group States-----------------------------
  BehaviorSubject _currentMenuGroup = BehaviorSubject.seeded('j');
  Observable get currentMenuGroupStream$ => _currentMenuGroup.stream;

  changeCurrentMenuGroup(String val){
    _currentMenuGroup.add(val);
  }

  //------------------------------Menu Group States-----------------------------
  BehaviorSubject _loginStatus = BehaviorSubject.seeded(false);
  Observable get currentLoginStatusStream$ => _loginStatus.stream;

  changeCurrentLoginStatus(bool val){
    _loginStatus.add(val);
  }

}

ManageStatesBloc manageStatesBloc=ManageStatesBloc();