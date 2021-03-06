import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view_models/feed_vieew_model.dart';
import 'package:insta_clone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';

class PostCaptionInputTextField extends StatefulWidget {
  final String? captionBeforeUpdated;
  final PostCaptionOpenMode? from;


  PostCaptionInputTextField({this.captionBeforeUpdated, this.from});

  @override
  _PostCaptionInputTextFieldState createState() => _PostCaptionInputTextFieldState();
}

class _PostCaptionInputTextFieldState extends State<PostCaptionInputTextField> {
  final _captionController = TextEditingController();

  @override
  void initState() {
    _captionController.addListener(_omCaptionUpdated);

    if(widget.from == PostCaptionOpenMode.FROM_FEED){
      _captionController.text = widget.captionBeforeUpdated!;
    }

    super.initState();
  }


  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _captionController,
      style: postCaptionTextStyle,
      autofocus: true,
      decoration: InputDecoration(
        hintText: S.of(context).inputCaption,
        border: InputBorder.none,
      ),


    );
  }
  _omCaptionUpdated(){
    if(widget.from == PostCaptionOpenMode.FROM_FEED){
      final viewModel = Provider.of<FeedViewModel>(context, listen: false);
      viewModel.caption = _captionController.text;
      print("caption: ${viewModel.caption}");
    }else{
      final viewModel = Provider.of<PostViewModel>(context, listen: false);
      viewModel.caption = _captionController.text;
      print("caption: ${viewModel.caption}");
    }
}

}
