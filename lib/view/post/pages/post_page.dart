import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:insta_clone/view/common/components/button_with_icon.dart';
import 'package:insta_clone/view/post/screens/post_upload_screen.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ButtonWithIcon(
                iconData: FontAwesomeIcons.images,
                label: S.of(context).gallery,
                color: Colors.deepPurpleAccent,
                //ToDO
                onPressed: () =>
                    _openPostUploadScreen(UploadType.GALLERY, context),
              ),
              SizedBox(
                height: 24.0,
              ),
              ButtonWithIcon(
                iconData: FontAwesomeIcons.camera,
                label: S.of(context).camera,
                color: Colors.deepPurpleAccent,
                //ToDO
                onPressed: () =>
                    _openPostUploadScreen(UploadType.CAMERA, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openPostUploadScreen(UploadType uploadType, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostUploadScreen(uploadType: uploadType),
      ),
    );
  }
}
