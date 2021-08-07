import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/common/dialog/confirm_dialog.dart';
import 'package:insta_clone/view/post/components/post_caption_part.dart';
import 'package:insta_clone/view/post/components/post_location_part.dart';
import 'package:insta_clone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

//postPageから遷移
class PostUploadScreen extends StatefulWidget {
  final UploadType uploadType;

  PostUploadScreen({ required this.uploadType});
  @override
  State<PostUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  @override
  Widget build(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context,
        listen: false); //メソッドを投げてConsumerで受け取る

    if (!postViewModel.isImagePicked && !postViewModel.isProcessing) {
      Future(() => postViewModel.pickImage(widget.uploadType));
    }
    return Consumer<PostViewModel>(
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              leading: model.isProcessing
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => _cancelPost(context),
                    ),
              title: model.isProcessing
                  ? Text(S.of(context).underProcessing)
                  : Text(S.of(context).post),
              actions: [
                (model.isProcessing || !model.isImagePicked)
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _cancelPost(context),
                      )
                    : IconButton(
                        icon: Icon(Icons.done),
                        //ダイアログを出して投稿処理
                        onPressed: () => showConfirmDialog(
                            context: context,
                            title: S.of(context).post,
                            content: S.of(context).postConfirm,
                            onConfirmed: (isConfirmed){
                              if (isConfirmed){
                                _post(context);//投稿処理
                              }
                            }),
                      )
              ],
            ),
            body: model.isProcessing
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : model.isImagePicked
                    ? Column(
                        children: [
                          Divider(),
                          PostCaptionPart(
                            from: PostCaptionOpenMode.FROM_POST,
                          ),
                          Divider(),
                          PostLocationPart(),
                          Divider(),
                        ],
                      )
                    : Container());
      },
    );
  }

  _cancelPost(BuildContext context) {
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
     postViewModel.cancelPost();
    Navigator.pop(context);
  }

  void _post(BuildContext context) async{
    final postViewModel = Provider.of<PostViewModel>(context, listen: false);
    await postViewModel.post();
    Navigator.pop(context);
  }
}
