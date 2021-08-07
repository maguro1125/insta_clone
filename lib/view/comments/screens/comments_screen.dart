import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/view/comments/components/comment_display_part.dart';
import 'package:insta_clone/view/comments/components/comment_input_part.dart';
import 'package:insta_clone/view/common/dialog/confirm_dialog.dart';
import 'package:insta_clone/view_models/comments_view_model.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatelessWidget {
  final Post post;
  final User postUser;

  CommentsScreen({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final commentsViewModel =
        Provider.of<CommentsViewModel>(context, listen: false);

    Future(() => commentsViewModel.getComments(post.postId));

    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).comments),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //キャプション
                CommentDisplayPart(
                  postUserPhotoUrl: postUser.photoUrl,
                  name: postUser.inAppUserName,
                  text: post.caption,
                  postDateTime: post.postDateTime,
                ),
                //コメントのリスト
                Consumer<CommentsViewModel>(
                  builder: (context, model, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.comments.length,
                      itemBuilder: (context, index) {
                        final comment = model.comments[index];
                        final commentUserId = comment.commentUserID;
                        return FutureBuilder(
                          future: model.getCommentUserInfo(commentUserId),
                          builder: (context, AsyncSnapshot<User> snapshot) {
                            // if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.hasData) {
                              final commentUser = snapshot.data!;
                              return CommentDisplayPart(
                                postUserPhotoUrl: commentUser.photoUrl,
                                name: commentUser.inAppUserName,
                                text: comment.comment,
                                postDateTime: comment.commentDateTime,
                                onLongPressed: () => showConfirmDialog(
                                  context: context,
                                  title: S.of(context).deleteComment,
                                  content: S.of(context).deleteCommentConfirm,
                                  onConfirmed: (isConfirmed){
                                    if (isConfirmed){
                                      _deleteComment(context, index);
                                    }
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  },
                ),
                //コメント入力欄
                CommentInputPart(
                  post: post,
                ),
              ],
            ),
          ),
        ));
  }

  void _deleteComment(BuildContext context, int commentIndex) async{
    final commentsViewModel = Provider.of<CommentsViewModel>(context, listen: false);
    await commentsViewModel.deleteComment(post, commentIndex);
  }
}
