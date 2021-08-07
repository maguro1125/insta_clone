import 'package:flutter/material.dart';

const TitleFont = "Billabong";
const RegularFont = "NotoSansJP-Medium";
const BoldFont = "NotoSansJP-Bold";

//テーマ
final darkTheme = ThemeData(
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: Colors.deepPurpleAccent,
        ),
    ),
    primaryIconTheme: IconThemeData(
        color: Colors.white30,
    ),
    iconTheme: IconThemeData(
        color: Colors.white,
    ),
    fontFamily: RegularFont,
);

final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: Colors.deepPurple,
        ),
    ),
    primaryIconTheme: IconThemeData(
        color: Colors.black87,
    ),
    iconTheme: IconThemeData(
        color: Colors.black87,
    ),
    fontFamily: RegularFont,
);


//Login
const loginTitleTextStyle = TextStyle(fontFamily: TitleFont, fontSize: 40.0);

//Post
const postCaptionTextStyle = TextStyle(fontFamily: RegularFont, fontSize: 14.0);
const postLocationTextStyle = TextStyle(fontFamily: RegularFont, fontSize: 16.0);

//FEED
const userCardTitleTextStyle= TextStyle(
  fontFamily: BoldFont, fontSize: 14.0
);
const userCardSubTitleTextStyle = TextStyle(
  fontFamily: RegularFont, fontSize: 12.0
);

const numberOfLikesTextStyle = TextStyle(
  fontFamily: RegularFont, fontSize: 14.0
);

const numberOfCommentsTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 13.0, color: Colors.grey
);

const timeAgoTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 10.0, color:  Colors.grey
);

const CommentNameTextStyle = TextStyle(
    fontFamily: BoldFont, fontSize: 13.0,
);

const CommentContentTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 13.0,
);

const CommentInputTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 14.0,
);

const profileRecordTextStyle = TextStyle(
    fontFamily: BoldFont, fontSize: 20.0,
);

const profileRecordTitleTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 14.0,
);

const changeProfilePhotoTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 18.0, color: Colors.blueAccent,
);

const editProfileTitleTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 14.0,
);

const profileBioTextStyle = TextStyle(
    fontFamily: RegularFont, fontSize: 13.0,
);

const searchPageAppBarTitleTextStyle = TextStyle(
    fontFamily: RegularFont,  color: Colors.grey
);