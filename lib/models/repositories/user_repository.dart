import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth; // Userクラスとの差別化をするため
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/db/database_manager.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final DatabaseManager dbManager;

  UserRepository({required this.dbManager});

  static User? currentUser;

  //インスタンスの作成
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //GoogleLoginの認証処理の実装
  Future<bool> isSingIn() async {
    final firebaseUser =  _auth.currentUser;
    if (firebaseUser != null) {
      currentUser = await dbManager
          .getUserInfoFromDbById(firebaseUser.uid); //ユーザーデータを全体で使えるようにする
      return true;
    }
    return false;
  }

  //外注処理
  Future<bool> signIn() async {
    try {
      GoogleSignInAccount? signInAccount =
      await _googleSignIn.signIn(); //サインインして
      //[Null-Safety] signInAccountをNullableにしたのでNullチェック＋早期リターン
      if (signInAccount == null) return false;

      GoogleSignInAuthentication signInAuthentication =
      await signInAccount.authentication; //認証する

      //サインイン認証情報を元にアクセスする暗号をとってくる
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      //アクセスする暗号を元に認証を実行する
      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return false;
      }
      // DBにいなければ登録
      final isUserExitedInDb = await dbManager.searchUserInDb(firebaseUser);
      if (!isUserExitedInDb) {
        await dbManager.insertUser(_convertToUser(firebaseUser));
      }
      currentUser = await dbManager
          .getUserInfoFromDbById(firebaseUser.uid); //ユーザーデータを全体で使えるようにする
      return true;
    } catch (error) {
      print("sign in error caught!: ${error.toString()}");
      return false;
    }
  }

  //モデルクラスのユーザーを入れるためにfirebaseUserの形をしたクラスを変換する
  _convertToUser(auth.User firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      //[Null-Safety] Nullチェック必要に
      displayName: firebaseUser.displayName ?? "",
      inAppUserName: firebaseUser.displayName ?? "",
      //アプリの中で変更するからdisplayName
      photoUrl: firebaseUser.photoURL ?? "",
      email: firebaseUser.email ?? "",
      bio: "",
    );
  }

  Future<User> getUserById(String userId) async {
    return await dbManager.getUserInfoFromDbById(userId);
  }

  Future<void> signOut() async {
    // await _googleSignIn.disconnect()/完全にログアウト
    await _googleSignIn.signOut();
    await _auth.signOut();
    currentUser = null; // nullにしないと残すとstaticの中に残ってしまう
  }

  Future<int> getNumberOfFollowers(User profileUser) async {
    return (await dbManager.getFollowerUserIds(profileUser.userId)).length;
  }

  Future<int> getNumberOfFollowings(User profileUser) async {
    return (await dbManager.getFollowingUserIds(profileUser.userId)).length;
  }

  Future<void> upDateProfile(User profileUser,
      String namedUpdated,
      String bioUpdated,
      String photoUrlUpdated,
      bool isImageFromFile,) async {
    var updatePhotoUrl;

    //TODO
    if (isImageFromFile) {
      final updatePhotoProfile = File(photoUrlUpdated);
      final storagePath = Uuid().v1();
      updatePhotoUrl =
      await dbManager.uploadImageToStorage(updatePhotoProfile, storagePath);
    }
    final userBeforeUpdated = await dbManager.getUserInfoFromDbById(
        profileUser.userId);
    final updateUser = userBeforeUpdated.copyWith(
      inAppUserName: namedUpdated,
      photoUrl: isImageFromFile ? updatePhotoUrl : userBeforeUpdated.photoUrl,
      bio: bioUpdated,
    );
    await dbManager.updateProfile(updateUser);

  }

  Future<void> getCurrentUserById(String userId) async{
    currentUser = await dbManager.getUserInfoFromDbById(userId);
  }

  Future<List<User>> searchUsers(String query) async{
    return dbManager.searchUsers(query);
  }

  Future<void> follow(User profileUser) async{
    if(currentUser != null) await dbManager.follow(profileUser, currentUser!);//currentUser user内のサブコレクションで必要
  }

  Future<void> unFollow(User profileUser) async{
    if(currentUser != null) await dbManager.unFollow(profileUser, currentUser!);
  }

  Future<List<User>> getCaresMeUser(String id, WhoCaresMode mode) async{
    var results = <User>[];

    switch (mode){
      case WhoCaresMode.LIKE:
        final postId = id;
        results = await dbManager.getLikesUsers(postId);//誰にいいねして貰ってるのか
        break;
      case WhoCaresMode.FOLLOWED:
        final profileUserId = id;
        results = await dbManager.getFollowerUsers(profileUserId);//誰がフォロワーか
        break;
      case WhoCaresMode.FOLLOWINGS:
        final profileUserId = id;
        results = await dbManager.getFollowingUsers(profileUserId);//誰をフォローしているのか
        break;
    }
    return results;
  }
}
