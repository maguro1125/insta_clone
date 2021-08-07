import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/comments.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/functions.dart';
import 'package:insta_clone/view/comments/screens/comments_screen.dart';
import 'package:insta_clone/view/common/components/comment_rich_text.dart';
import 'package:insta_clone/view_models/feed_vieew_model.dart';
import 'package:provider/provider.dart';

class FeedPostCommentsPart extends StatelessWidget {
  final Post post;
  final User postUser;


  FeedPostCommentsPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = Provider.of<FeedViewModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          //投稿者名都キャプション
          CommentRichText(
            name: postUser.inAppUserName,
            text: post.caption,
          ),
          InkWell(
            onTap: () => _openCommentsScreen(context, post, postUser),
            child: FutureBuilder(
              future: feedViewModel.getComments(post.postId),
              builder: (context, AsyncSnapshot<List<Comment>> snapshot){
                if(snapshot.hasData && snapshot.data !=null){
                  final comments = snapshot.data!;
                  return  Text(
                    comments.length.toString() + " " + S.of(context).comments,
                    style: TextStyle(color: Colors.grey),
                );
                }else{
                  return Container();
                }
            },
            ),
          ),
          Text(
            createTimeAgoString(post.postDateTime),
            style: timeAgoTextStyle,
          )
        ],
      ),
    );
  }

  _openCommentsScreen(BuildContext context, Post post, User postUser) {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) =>
            CommentsScreen(
              post: post,
              postUser: postUser,
            ),),);
  }
}
