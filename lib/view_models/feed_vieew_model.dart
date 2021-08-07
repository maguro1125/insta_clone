import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/comments.dart';
import 'package:insta_clone/data_model/like.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/repositories/post_repository.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';
import 'package:insta_clone/utils/constant.dart';

class FeedViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;

  String caption = "" ;

  FeedViewModel({ required this.userRepository, required this.postRepository});

  bool isProcessing = false;
  List<Post> posts = [];//結果を入れるためのプロパティ

  late User feedUSer;
  User get currentUser => UserRepository.currentUser!;

  void setFeedUSer(FeedMode feedMode, User? user){
    if (feedMode == FeedMode.FROM_FEED){
      feedUSer = currentUser;
    } else{
      feedUSer = user!;
    }
  }//どのユーザーを表示するのか

  Future<void>getPosts(FeedMode feedMode) async{
    isProcessing = true;
    notifyListeners();

   posts =  await postRepository.getPosts(feedMode, feedUSer);//データを取ってくる
    isProcessing = false;
    notifyListeners();

  }

  Future<User>getPostUserInfo(String userId) async{
    return await userRepository.getUserById(userId);
  }

  Future<void>updatePost(Post post, FeedMode feedMode) async{
    isProcessing = true;

    await postRepository.updatePost(
      post.copyWith(caption: caption)
    );

    await getPosts(feedMode);

    isProcessing = false;
    notifyListeners();
  }

  Future<List<Comment>> getComments(String postId) async{
    return await postRepository.getComments(postId);
  }

  Future<void>likeIt(Post post)async {
    await postRepository.likeIt(post, currentUser);
    notifyListeners();
  }

  Future<void>unLikeIt(Post post) async{
    await postRepository.unLikeIt(post, currentUser);
    notifyListeners();
  }


  Future<LikeResult>getLikesResult(String postId) async{
    return await postRepository.getLikesResult(postId, currentUser);
  }

  Future<void>deletePost(Post post, FeedMode feedMode) async{
    isProcessing = true;
    notifyListeners();

    await postRepository.deletePost(post.postId, post.imageStoragePath);
    await getPosts(feedMode);
    isProcessing = false;
    notifyListeners();
  }





}