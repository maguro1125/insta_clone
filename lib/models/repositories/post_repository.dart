import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/data_model/comments.dart';
import 'package:insta_clone/data_model/like.dart';
import 'package:insta_clone/data_model/location.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/db/database_manager.dart';
import 'package:insta_clone/models/location/location_manager.dart';
import 'package:insta_clone/utils/constant.dart';
import 'package:uuid/uuid.dart';

class PostRepository {
  final DatabaseManager dbManager;
  final LocationManager locationManager;

  PostRepository({required this.dbManager, required this.locationManager});

    // [Null-Safety] 戻り値をNullableに
    Future<File?> pickImage(UploadType uploadType) async {
      final imagePicker = ImagePicker();
      if (uploadType == UploadType.GALLERY) {
        final pickedImage =
        await imagePicker.getImage(source: ImageSource.gallery);
        //[Null-Safety] 戻り値がNullableなのでNullチェック要
        return (pickedImage != null) ? File(pickedImage.path): null;
      } else {
        final pickedImage =
        await imagePicker.getImage(source: ImageSource.camera);
        //[Null-Safety] 戻り値がNullableなのでNullチェック要
        return (pickedImage != null) ? File(pickedImage.path): null;
      }
    }


  Future<Location> getCurrentLocation() async {
    return await locationManager.getCurrentLocation();
  }

  Future<Location> updateLocation(double latitude, double longitude) async {
    return await locationManager.updateLocation(latitude, longitude);
  }

  //storageに画像を保存して、storageの場所のパスをデータベースに登録
  Future<void> post(User currentUser, File imageFile, String caption,
      Location? location, String locationString) async {
    final storageId = Uuid().v1(); //たった一つのIDを作る
    final imageUrl = await dbManager.uploadImageToStorage(
        imageFile, storageId); //画像をstorageにあげて場所をとってくる
    // print("storageImageUrl: $imageUrl");
    //データベースに登録するためにデータクラスに変換
    final post = Post(
      postId: Uuid().v1(),
      userId: currentUser.userId,
      imageUrl: imageUrl,
      imageStoragePath: storageId,
      caption: caption,
      locationString: locationString,
      // [Null-Safety] locationがNullなのでNullチェック要
      latitude: (location != null) ? location.latitude : 0.0,
      longitude:  (location != null) ? location.longitude : 0.0,
      postDateTime: DateTime.now(),
    );
    await dbManager.insertPost(post);
  }


  Future<List<Post>> getPosts(FeedMode feedMode, User feedUser) async {
    if (feedMode == FeedMode.FROM_FEED) {
      //自分+フォローしているユーザーの投稿を取得
      return dbManager.getPostsMineAndFollowings(feedUser.userId);
    } else {
      //プロフィール画面に表示されるユーザーのみを取得
      return dbManager.getPostsByUser(feedUser.userId);
    }
  }

  Future<void> updatePost(Post updatePost) async {
    return dbManager.updatePost(updatePost);
  }

  Future<void> postComment(
      Post post, User commentUser, String commentString) async {
    final comment = Comment(
        postID: post.postId,
        comment: commentString,
        commentDateTime: DateTime.now(),
        commentUserID: commentUser.userId,
        commentID: Uuid().v1());
    await dbManager.postComment(comment);
  }

  Future<List<Comment>> getComments(String postId) async {
    return   dbManager.getComments(postId);
  }

  Future<void>deleteComment(String deleteCommentId) async{
    await dbManager.deleteComment(deleteCommentId);
  }

  Future<void>likeIt(Post post, User currentUser) async{
      final like = Like(
        likeUserId: currentUser.userId,
        likeId:  Uuid().v1(),
        postId: post.postId,
        likeDateTime: DateTime.now(),
      );
      await dbManager.likeIt(like);
  }

  Future<void>unLikeIt(Post post, User currentUser) async{
      await dbManager.unLikeIt(post, currentUser);
  }



  Future<LikeResult>getLikesResult(String postId, User currentUser) async {
    //いいねの投稿
    final likes = await dbManager.getLikes(postId);
    //自分がその投稿にいいねを押してかどうか
    var isLikedPost = false;
    for (var like in likes) {
      if (like.likeUserId == currentUser.userId) {
        isLikedPost = true;
        break;
      }
    }
    return LikeResult(likes: likes, isLikeToThisPost: isLikedPost);
  }

  Future<void>deletePost(String postId, String imageStoragePath) async{
      await dbManager.deletePost(postId, imageStoragePath);
  }



}




