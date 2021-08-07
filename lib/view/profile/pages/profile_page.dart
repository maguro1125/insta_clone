import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/profile/components/profile_detail_part.dart';
import 'package:insta_clone/view/profile/components/profile_post_grid_part.dart';
import 'package:insta_clone/view/profile/components/profile_setting_part.dart';
import 'package:insta_clone/view_models/profile_view_model.dart';
import 'package:insta_clone/view_models/who_cares_me_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final ProfileMode profileMode;
  final User? selectedUser;

  final bool isOpenFromProfileScreen;

  final String? popProfileUserId;

  ProfilePage({required this.profileMode, this.selectedUser, required this.isOpenFromProfileScreen, this.popProfileUserId,});

  @override
  Widget build(BuildContext context) {
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    profileViewModel.setProfileUser(profileMode, selectedUser, popProfileUserId);

    Future(() => profileViewModel.getPost());

    return Scaffold(body: Consumer<ProfileViewModel>(
      builder: (context, model, child) {
        final profileUser = model.profileUser;
        print("profileUser in ProfilePage: $profileUser");
        print("profileMode in ProfilePage: $profileMode");
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(profileUser.inAppUserName),
                leadingWidth: (!isOpenFromProfileScreen) ?  0.0 : 56.0,
                leading: (!isOpenFromProfileScreen) ? Container(): IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    model.popProfileUser();
                   _popWithRebuildWhoCaredMeScreen(context, model.popProfileUserId);
                  },
                ),
                pinned: true,
                floating: true,
                centerTitle: false,
                actions: [
                  ProfileSettingPart(
                    mode: profileMode,
                  )
                ],
                expandedHeight: 289.0,
                //TODO ProfileDetailPart
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileDetailPart(
                    mode: profileMode,
                  ),
                ),
              ),
              ProfilePostsGridPart(
                posts: model.posts,
              )
            ],
          ),
        );
      },
    ));
  }

  void _popWithRebuildWhoCaredMeScreen(BuildContext context, String popProfileUserId) {
    final whoCaresMeViewModel = context.read<WhoCaresMeViewModel>();
    whoCaresMeViewModel.rebuildAfterPop(popProfileUserId);
    Navigator.pop(context);
  }
}
