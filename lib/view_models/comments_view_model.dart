import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/comments.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/repositories/post_repository.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';

class CommentsViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;

  User? get currentUser => UserRepository.currentUser;

  bool isLoading = false;

  String comment = "";

  List<Comment> comments = [];

  CommentsViewModel({required this.userRepository, required this.postRepository});

  Future<void> postComment(Post post) async {
    await postRepository.postComment(post, currentUser!, comment);
    getComments(post.postId);
    notifyListeners();
  }

  Future<void> getComments(String postId) async {
    isLoading = true;
    notifyListeners();

    // comments = await postRepository.getComments(postId);
    comments = await postRepository.getComments(postId);

    print("comments from DB: $comments");

    isLoading = false;
    notifyListeners();
  }

  Future<User> getCommentUserInfo(String commentUserId) async{
   return await userRepository.getUserById(commentUserId);
  }

  Future<void>deleteComment(Post post, int commentIndex) async{
    final deleteCommentId = comments[commentIndex].commentID;
    await postRepository.deleteComment(deleteCommentId);
    getComments(post.postId);
    notifyListeners();
  }


}