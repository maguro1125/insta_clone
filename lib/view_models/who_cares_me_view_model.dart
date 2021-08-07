import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';
import 'package:insta_clone/utils/constant.dart';

class WhoCaresMeViewModel extends ChangeNotifier{
  final UserRepository userRepository;

  WhoCaresMeViewModel({required this.userRepository});

  List<User> caresMeUsers  = [];

  User get currentUser => UserRepository.currentUser!;

  WhoCaresMode whoCaresMeMode = WhoCaresMode.LIKE;

  WhoCaresMode whoCaresMode = WhoCaresMode.LIKE;

  Future<void> getCaresMeUsers(String id, WhoCaresMode mode) async{
    whoCaresMode = mode;

    caresMeUsers =  await userRepository.getCaresMeUser(id, mode);
    print("who cares me: $caresMeUsers");
    notifyListeners();
  }

  void rebuildAfterPop(String popProfileUserId) {
    getCaresMeUsers(popProfileUserId, whoCaresMode);
  }

}