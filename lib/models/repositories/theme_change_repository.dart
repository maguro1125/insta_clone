
import 'package:shared_preferences/shared_preferences.dart';

const PREF_KEY = "isDarkOn";

class ThemeChangeRepository {

  static bool isDarkOn = false;

  //テーマの設定
  Future<void> setTheme(bool isDark) async {
    print("setTheme in repo start: $isDark");
    final prefs = await SharedPreferences.getInstance(); //インスタンス取得
    await prefs.setBool(PREF_KEY, isDark);//boolのデータを保存
    isDarkOn = isDark;
    print("setTheme in repo end: $isDarkOn");
  }


  //保存したテーマのデータを持ってくる
  Future<void>getIsDarkOn() async{
    final prefs = await SharedPreferences.getInstance();//インスタンス取得
    isDarkOn =  prefs.getBool(PREF_KEY) ?? true ;//boolのデータを取得
  }

}