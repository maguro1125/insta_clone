import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/post.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/repositories/post_repository.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';
import 'package:insta_clone/utils/constant.dart';

class ProfileViewModel extends ChangeNotifier {

  final UserRepository userRepository;
  final PostRepository postRepository;

  ProfileViewModel(
      {required this.userRepository, required this.postRepository });

  late User profileUser;

  User get currentUser => UserRepository.currentUser!;

  bool isProcessing = false;

  bool isFollowingProfileUser = false;

  List<Post> posts = [];

  List<String> popProfileUserIds = [];
  String popProfileUserId = "";

  void setProfileUser(ProfileMode profileMode, User? selectedUser, String? popProfileUserId) {

    if(popProfileUserId != null) popProfileUserIds.add(popProfileUserId);

    if (profileMode == ProfileMode.MYSELF) {
      profileUser = currentUser;
    } else {
      profileUser = selectedUser!;
    }
  }

  Future<void> getPost() async {
    isProcessing = true;
    notifyListeners();

    posts = await postRepository.getPosts(FeedMode.FROM_PROFILE, profileUser);

    isProcessing = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await userRepository.signOut();
    notifyListeners();
  }

  Future<int> getNumberOfPost() async {
    return (await postRepository.getPosts(FeedMode.FROM_PROFILE, profileUser))
        .length;
  }

  Future<int> getNumberOfFollowers() async {
    return await userRepository.getNumberOfFollowers(profileUser);
  }

  Future<int> getNumberOfFollowings() async {
    return await userRepository.getNumberOfFollowings(profileUser);
  }

  //アイコンの変更
  Future<String> pickProfileImage() async {
    final pickedImage = await postRepository.pickImage(UploadType.GALLERY);

    return (pickedImage != null) ? pickedImage.path : "";
  }

  Future<void> updateProfile(String namedUpdated, String bioUpdated,
      String photoUrlUpdated, bool isImageFromFile) async {
    isProcessing = true;
    notifyListeners();

    await userRepository.upDateProfile(
        profileUser, namedUpdated, bioUpdated, photoUrlUpdated,
        isImageFromFile);

    //更新後にユーザーデータを再取得してstaticに保存
    await userRepository.getCurrentUserById(profileUser.userId);
    profileUser = currentUser;
    isProcessing = false;

    notifyListeners();

  }

  Future<void> follow() async{
    await userRepository.follow(profileUser);
    isFollowingProfileUser = true;
    notifyListeners();
  }

  Future<void> unFollow() async{
    await userRepository.unFollow(profileUser);
    isFollowingProfileUser = false;
    notifyListeners();
  }

  void popProfileUser() async{
    if(popProfileUserIds.isNotEmpty){
      popProfileUserId = popProfileUserIds.last;
      popProfileUserIds.removeLast();
      profileUser = await userRepository.getUserById(popProfileUserId);
    } else {
      profileUser = currentUser;
    }

    getPost();
  }

}