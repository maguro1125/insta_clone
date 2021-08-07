import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/data_model/comments.dart';
import 'package:insta_clone/data_model/like.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';

class DatabaseManager {
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; //fireStoreのインスタンスを取ってくる

  //ユーザーがいるかどうか
  Future<bool> searchUserInDb(auth.User firebaseUser) async {
    final query = await _db
        .collection("user")
        .where("userId", isEqualTo: firebaseUser.uid)
        .get(); //read
    if (query.docs.length > 0) {
      return true;
    }
    return false;
  }

  //データベースにユーザーを登録する
  Future<void> insertUser(User user) async {
    await _db
        .collection("users")
        .doc(user.userId)
        .set(user.toMap()); //insert・create
  }

  //dbからユーザーのデータを取ってくる-> user_repositoryでstatic変数に
  Future<User> getUserInfoFromDbById(String userId) async {
    final query =
    await _db.collection("users").where("userId", isEqualTo: userId).get();
    return User.fromMap(query.docs[0].data());
  }

  //画像をstorageにあげて場所をとってくる
  Future<String> uploadImageToStorage(File imageFile, String storageId) {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child(storageId); //storage上でファイルの保存場所のリファレンスを取得
    final uploadTask = storageRef.putFile(imageFile); //次にパスにファイルをアップロード
    return uploadTask.then((TaskSnapshot snapshot) =>
        snapshot.ref.getDownloadURL()); //アップロード処理の完了後にファイルのダウンロードURLを取得
  }

  //データベースに登録
  Future<void> insertPost(Post post) async {
    await _db.collection("posts").doc(post.postId).set(post.toMap());
  }

  //TODO
  Future<List<Post>> getPostsByUser(String userId) async {
    final query = await _db.collection("posts").get();
    if (query.docs.length == 0) return [];

    var results = <Post>[];
    await _db.collection("posts").where("userId", isEqualTo: userId).orderBy(
        "postDateTime", descending: true)
        .get().then((value) {
      value.docs.forEach((element) {
        results.add(Post.fromMap(element.data()));
      });
    });
    return results;
  }


  Future<List<Post>> getPostsMineAndFollowings(String userId) async {
    //データの有無を判定
    final query = await _db.collection("posts").get();
    if (query.docs.length == 0) return []; //データがない場合の処理をここで終わらせる

    var userIds = await getFollowingUserIds(userId); //フォローしているユーザーのIDを取ってくる
    userIds.add(userId);

    var results = <Post>[];
    await _db
        .collection("posts")
        .where("userId", whereIn: userIds)//リストに入っているuserIdを検索
        .orderBy(
      "postDateTime",
      descending: true,
    )
        .get()
        .then((value) {
      value.docs.forEach((element) {
        results.add(Post.fromMap(element.data()));
      });
    });
    print("posts: $results");
    return results;
  }

  Future<List<String>> getFollowingUserIds(String userId) async {
    final query = await _db
        .collection("users")
        .doc(userId)
        .collection("followings")
        .get();
    if (query.docs.length == 0) return [];

    var userIds = <String>[];
    query.docs.forEach(
          (id) {
        userIds.add(id.data()["userId"]);
      },
    );
    return userIds;
  }

  //フォロワーの数の計算
  Future<List<String>> getFollowerUserIds(String userId) async {
    final query = await _db.collection("users").doc(userId).collection(
        "followers").get();
    if (query.docs.length == 0) return [];
    var userIds = <String>[];
    query.docs.forEach((id) {
      userIds.add(id.data()["userId"]);
    });
    return userIds;
  }

  //誰にいいねして貰ってるのか
  Future<List<User>> getLikesUsers(String postId) async {
    final query = await _db.collection("likes").where(
        "postId", isEqualTo: postId).get();
    if (query.docs.length == 0) return [];
    var userIds = <String>[];
    query.docs.forEach((id) {
      userIds.add(id.data()["likeUserId"]);//いいねしてくれたユーザーのidを持ってくる
    });
    //順番にユーザーのデータをリスト形式で持ってくる
    var likesUsers = <User>[];
    //ループ処理全体を非同期処理で行う
    await Future.forEach(userIds, (String userId) async{
      final user = await getUserInfoFromDbById(userId);
      likesUsers.add(user);
    });
    print("誰がいいねしたか: $likesUsers");
    return likesUsers;
  }


  Future<void> updatePost(Post updatePost) async {
    final reference = _db.collection("posts").doc(updatePost.postId);

    await reference.update(updatePost.toMap());
  }

  Future<void> postComment(Comment comment) async {
    await _db
        .collection("comments")
        .doc(comment.commentID)
        .set(comment.toMap());
  }

  Future<List<Comment>> getComments(String postId) async {
    final query = await _db.collection("comments").get();

    //if (query.docs.length == 0) return List();
    if (query.docs.length == 0) return [];

    //var results = List<Comment>();
    var results = <Comment>[];

    await _db
        .collection("comments")
        .where("postID", isEqualTo: postId)
        .orderBy("commentDateTime")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        results.add(Comment.fromMap(element.data()));
      });
    });
    return results;
  }

  Future<void> deleteComment(String deleteCommentId) async {
    final reference = _db.collection("comments").doc(deleteCommentId);
    await reference.delete();
  }


  Future<void> likeIt(Like like) async {
    await _db.collection("likes").doc(like.likeId).set(like.toMap());
  }

  Future<List<Like>> getLikes(String postId) async {
    final query = await _db.collection("likes").get();
    if (query.docs.length == 0) return [];
    var results = <Like>[];
    await _db
        .collection("likes")
        .where("postId", isEqualTo: postId)
        .orderBy("likeDateTime")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        results.add(Like.fromMap(element.data()));
      });
    });
    return results;
  }

  Future<void> unLikeIt(Post post, User currentUser) async {
    final likeRef = await _db.collection("likes")
        .where(
        "postId", isEqualTo: post.postId) //二段で指定
        .where("likeUserId", isEqualTo: currentUser.userId)
        .get(); //指定したいいねのデータを取ってくる
    likeRef.docs.forEach((element) async {
      final ref = _db.collection("likes").doc(element.id);
      await ref.delete(); //いいねしたデータを削除
    });
  }

  //投稿削除処理
  Future<void> deletePost(String postId, String imageStoragePath) async {
    //Post
    final postRef = _db.collection("posts").doc(postId);
    await postRef.delete();

    //Comment
    final commentRef = await _db.collection("comments").where(
        "postID", isEqualTo: postId).get();
    commentRef.docs.forEach((element) async {
      final ref = _db.collection("comments").doc(element.id);
      await ref.delete();
    });

    //Likes
    final likeRef = await _db.collection("likes").where(
        "postId", isEqualTo: postId).get();
    likeRef.docs.forEach((element) async {
      final ref = _db.collection("likes").doc(element.id);
      await ref.delete();
    });

    //Storage
    final storageRef = FirebaseStorage.instance.ref().child(imageStoragePath);
    storageRef.delete();
  }

  //ユーザーアイコンのアップデート処理
  Future<void> updateProfile(User updateUser) async {
    final reference = _db.collection("users").doc(updateUser.userId);
    await reference.update(updateUser.toMap());
  }

  Future<List<User>> searchUsers(String queryString) async {
    final query = await _db.collection("users")
        .orderBy("inAppUserName") //orderByで並び替え
        .startAt([queryString]) //（[queryString]）で始まるデータを取ってくる(昇順のみだと最後まで出てしまう)
        .endAt([queryString + "\uf8ff"])
        .get(); //queryString で始まる検索をかけ、\uf8ffにすることで終わりを指定する
    if (query.docs.length == 0) return [];

    var soughtUsers = <User>[];
    query.docs.forEach((element) {
      final selectedUser = User.fromMap(element.data());
      if (selectedUser.userId != UserRepository.currentUser!.userId) {
        soughtUsers.add(selectedUser);
      }
    });
    return soughtUsers;
  }

  //fフォロー関係を表裏にしとく
  Future<void> follow(User profileUser, User currentUser) async {
    //currentUserにとってのfollowings
    await _db.collection("users").doc(currentUser.userId)
        .collection("followings").doc(profileUser.userId)
        .set({"userId": profileUser.userId});

    //profileUserにとってのfollowers
    await _db.collection("users").doc(profileUser.userId)
        .collection("followers").doc(currentUser.userId)
        .set({"userId": currentUser.userId});
  }

  //フォローを解除する
  Future<void> unFollow(User profileUser, User currentUser) async {
    //currentUserにとってのfollowingsからの消去
    await _db.collection("users").doc(currentUser.userId)
        .collection("followings").doc(profileUser.userId)
        .delete();

    //profileUserにとってのfollowersからの消去
    await _db.collection("users").doc(profileUser.userId)
        .collection("followers").doc(currentUser.userId)
        .delete();
  }

  //誰がフォロワーか
  Future<List<User>>getFollowerUsers(String profileUserId) async{
    final followerUserIds = await getFollowerUserIds(profileUserId);
    var followerUsers = <User>[];
    //ループ処理全体を非同期処理で行う
    await Future.forEach(followerUserIds, (String followerUserId) async{
      final user = await getUserInfoFromDbById(followerUserId);
      followerUsers.add(user);
    });
    return followerUsers;
  }

  //誰をフォローしているのか
  Future<List<User>>getFollowingUsers(String profileUserId) async{
    final followingUserIds = await getFollowingUserIds(profileUserId);
    var followingUsers = <User>[];
    //ループ処理全体を非同期処理で行う
    await Future.forEach(followingUserIds, (String followingUserId) async{
      final user = await getUserInfoFromDbById(followingUserId);
      followingUsers.add(user);
    });
    return followingUsers;
  }


}
