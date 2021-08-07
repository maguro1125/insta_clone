import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/user.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';

class SearchViewModel extends ChangeNotifier{
  final UserRepository userRepository;

  SearchViewModel({required this.userRepository});


  List<User> soughtUsers = [];

  Future<void> searchUsers(String query) async{
    soughtUsers =   await userRepository.searchUsers(query);
    notifyListeners();
  }


}