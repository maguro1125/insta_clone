import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/common/components/user_card.dart';
import 'package:insta_clone/view/common/dialog/confirm_dialog.dart';
import 'package:insta_clone/view/feed/screens/feed_post_edit_screen.dart';
import 'package:insta_clone/view/profile/screens/profile_screen.dart';
import 'package:insta_clone/view_models/feed_vieew_model.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class FeedPostHeaderPart extends StatelessWidget {
  final User postUser;
  final Post post;
  final User currentUser;
  final FeedMode feedMode;

  FeedPostHeaderPart({required this.postUser,
    required this.post,
    required this.currentUser,
    required this.feedMode});

  @override
  Widget build(BuildContext context) {
    return UserCard(
      photoUrl: postUser.photoUrl,
      title: postUser.inAppUserName,
      subTitle: post.locationString,
      onTap: () => _openProfile(context, postUser),
      //TODO
      trailing: PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (PostMenu value) => onPopupMenuSelected(context, value),
        itemBuilder: (context) {
          if (postUser.userId == currentUser.userId) {
            return [
              PopupMenuItem(
                value: PostMenu.EDIT,
                child: Text(S
                    .of(context)
                    .edit),
              ),
              PopupMenuItem(
                value: PostMenu.DELETE,
                child: Text(S
                    .of(context)
                    .delete),
              ),
              PopupMenuItem(
                value: PostMenu.SHARE,
                child: Text(S
                    .of(context)
                    .share),
              ),
            ];
          } else {
            return [
              PopupMenuItem(
                value: PostMenu.SHARE,
                child: Text(S
                    .of(context)
                    .share),
              ),
            ];
          }
        },
      ), //TODO
    );
  }

  //TODO
  onPopupMenuSelected(BuildContext context, PostMenu selectedMenu) {
    switch (selectedMenu) {
      case PostMenu.EDIT:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FeedPostEditScreen(
                  post: post,
                  postUser: postUser,
                  feedMode: feedMode,
                ),
          ),
        );
        break;
      case PostMenu.SHARE:
        Share.share(post.imageUrl, subject: post.caption,);
        break;
      case PostMenu.DELETE:
        showConfirmDialog(
            context: context,
            title: S
                .of(context)
                .deletePost,
            content: S
                .of(context)
                .deletePostConfirm,
            onConfirmed: (isConfirmed) {
              if (isConfirmed) _deletePost(context, post);
            }
        );
    }
  }

  void _deletePost(BuildContext context, Post post) async {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    await feedViewModel.deletePost(post, feedMode);
  }

  _openProfile(BuildContext context, User postUser) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            ProfileScreen(
              profileMode: postUser.userId == feedViewModel.currentUser.userId
                  ? ProfileMode.MYSELF
                  : ProfileMode.OTHER,
              selectedUser: postUser,
              popProfileUserId: currentUser.userId,
            )
    ));
  }
}
