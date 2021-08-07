import 'package:flutter/material.dart';
import 'package:insta_clone/models/repositories/theme_change_repository.dart';
import 'package:insta_clone/style.dart';

class ThemeChangeViewModel extends ChangeNotifier{
  final ThemeChangeRepository repository;

  ThemeChangeViewModel({required this.repository});

  bool  get isDarkOn => ThemeChangeRepository.isDarkOn; //staticでインスタンスを経由せず取ってこれる

  ThemeData get selectedTheme => isDarkOn ? darkTheme : lightTheme; //Themeデータを取ってくる

  void setTheme(bool isDark) async{
    await repository.setTheme(isDark);
    notifyListeners();
  }

}