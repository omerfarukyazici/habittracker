import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  //initally light mode

  ThemeData _themeData=lightMode;

  //get the current theme
  ThemeData get themeData => _themeData;

  //is dark mode

  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData){
    _themeData=themeData;
    notifyListeners();
  }
  //notify listener statemanagement durumunda güncelleme için kullanılan ChangeNotifer yöntemidir

  //toggle theme
  void toggleTheme(){
    if(_themeData==lightMode) {
      themeData=darkMode;
    }else{
      themeData=lightMode;
    }
  }

}