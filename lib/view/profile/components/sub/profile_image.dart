
import 'package:flutter/material.dart';
import 'package:insta_clone/view/common/components/circle_photo.dart';
import 'package:insta_clone/view_models/profile_view_model.dart';
import 'package:provider/src/provider.dart';

class ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;
    return CirclePhoto(
      photoUrl: profileUser.photoUrl,
      isImageFromFile: false,
      radius: 35.0,
    );
  }
}
