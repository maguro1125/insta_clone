import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/who_cares_me/screens/who_cares_me_screen.dart';
import 'package:insta_clone/view_models/profile_view_model.dart';
import 'package:provider/src/provider.dart';

class ProfileRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileVewModel = context.read<ProfileViewModel>();

    return Row(
      children: [
        FutureBuilder(
          future: profileVewModel.getNumberOfPost(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S
                  .of(context)
                  .post,
            );
          },
        ),
        FutureBuilder(
          future: profileVewModel.getNumberOfFollowers(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S
                  .of(context)
                  .followers,
              whoCaresMode: WhoCaresMode.FOLLOWED,
            );
          },
        ),
        FutureBuilder(
          future: profileVewModel.getNumberOfFollowings(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S
                  .of(context)
                  .followings,
              whoCaresMode: WhoCaresMode.FOLLOWINGS,
            );
          },
        )
      ],
    );
  }

  _userWidget(
      {required BuildContext context, required int score, required String title, WhoCaresMode? whoCaresMode,}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: whoCaresMode == null
            ? null
            : () => _checkFollowUser(context, whoCaresMode),
        child: Column(
          children: [
            Text(
              score.toString(),
              style: profileRecordTextStyle,
            ),
            Text(
              title.toString(),
              style: profileRecordTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  _checkFollowUser(BuildContext context, WhoCaresMode whoCaresMode) {
    final profileVewModel = context.read<ProfileViewModel>();
    final profileUser = profileVewModel.profileUser;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) =>
          WhoCaresMeScreen(
            mode: whoCaresMode,
            id: profileUser.userId,
          ),
    ),);
  }
}
