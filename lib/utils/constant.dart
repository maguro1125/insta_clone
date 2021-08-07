enum UploadType{
  GALLERY,
  CAMERA,
}

enum PostCaptionOpenMode {
  FROM_POST,
  FROM_FEED,
}

enum FeedMode{
  FROM_FEED,//自分とフォローしているユーザー
  FROM_PROFILE,//プロフィール画面に表示されるユーザーののみ
}

enum PostMenu{
  EDIT,
  DELETE,
  SHARE
}

enum ProfileMode{
  MYSELF,
  OTHER,
}

enum ProfileSettingMenu {
  THEME_CHANGE,
  SIGN_OUT
}

enum WhoCaresMode {
  LIKE,
  FOLLOWINGS,
  FOLLOWED,
}