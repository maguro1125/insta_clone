import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/data_model/like.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/comments/screens/comments_screen.dart';
import 'package:insta_clone/view/who_cares_me/screens/who_cares_me_screen.dart';
import 'package:insta_clone/view_models/feed_vieew_model.dart';
import 'package:provider/provider.dart';

class FeedPostLikesPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostLikesPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: FutureBuilder(
        future: feedViewModel.getLikesResult(post.postId),
        builder: (context, AsyncSnapshot<LikeResult> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final likeResult = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //いいねを押した時
                    likeResult.isLikeToThisPost // すでに押されている場合-> いいねやめる
                        ? IconButton(
                      icon: FaIcon(FontAwesomeIcons.solidHeart, color: Colors.grey,),
                      onPressed: () => _unLikeIt(context),
                    )
                        : IconButton(
                      icon: FaIcon(FontAwesomeIcons.heart, color: Colors.grey,),
                      onPressed: () => _likeIt(context),
                    ),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.comment,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          _openCommentsScreen(context, post, postUser),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _checkLikesUser(context),
                  child: Text(
                    likeResult.likes.length.toString() + " " + S
                        .of(context)
                        .likes,
                    style: numberOfLikesTextStyle,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }


  _openCommentsScreen(BuildContext context, Post post, User postUser) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CommentsScreen(
              post: post,
              postUser: postUser,
            ),
      ),
    );
  }

  //いいねする
  _likeIt(BuildContext context) async {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    await feedViewModel.likeIt(post);
  }

  //いいねをやめる
  _unLikeIt(BuildContext context) async{
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    await feedViewModel.unLikeIt(post);
  }

  _checkLikesUser(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => WhoCaresMeScreen(
        mode: WhoCaresMode.LIKE,
        id: post.postId,
      )
    ),);
  }
}
