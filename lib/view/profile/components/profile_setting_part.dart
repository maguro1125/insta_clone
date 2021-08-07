import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/login/login_screen.dart';
import 'package:insta_clone/view_models/profile_view_model.dart';
import 'package:insta_clone/view_models/theme_change_view_model.dart';
import 'package:provider/provider.dart';

class ProfileSettingPart extends StatelessWidget {

  final ProfileMode mode;

  ProfileSettingPart({required this.mode});

  @override
  Widget build(BuildContext context) {
    final themeChangeViewModel = Provider.of<ThemeChangeViewModel>(context);
    final isDarkOn = themeChangeViewModel.isDarkOn;
    print("isDarkOn in Profile; $isDarkOn");
    return PopupMenuButton(
      icon: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Icon(Icons.settings, size: 40.0, color: Colors.grey,),
      ),
      onSelected:  (ProfileSettingMenu value) => _onPopupMenuSelected(context, value, isDarkOn),
      itemBuilder: (context){
        if(mode == ProfileMode.MYSELF){
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: isDarkOn ? Text(S.of(context).changeToLightTheme)
                  : Text(S.of(context).changeToDarkTheme),
            ),
            PopupMenuItem(
              value: ProfileSettingMenu.SIGN_OUT,
              child: Text(S.of(context).signOut),
            ),
          ];
        }else {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: Text(S.of(context).changeToLightTheme),
            ),
          ];
        }
      },
    );
  }

  _onPopupMenuSelected(BuildContext context, ProfileSettingMenu selectedMenu, bool isDarkOn) {
    switch(selectedMenu){
      case ProfileSettingMenu.THEME_CHANGE:
        final themeChangeViewModel = context.read<ThemeChangeViewModel>();
        themeChangeViewModel.setTheme(!isDarkOn);
        break;
      case ProfileSettingMenu.SIGN_OUT:
        _signOut(context);
        break;
    }
  }

  void _signOut(BuildContext context) async{
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    await profileViewModel.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()
    ),
    );
  }
}
