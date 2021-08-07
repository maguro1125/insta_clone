import 'package:flutter/material.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  LoginViewModel({ required this.userRepository});

  bool isLoading = false;
  bool isSuccessful = false;


  Future<bool> isSingIn()async {
    return await userRepository.isSingIn();
  }

  Future<void>signIn()  async{
    isLoading = true;
    notifyListeners();

    isSuccessful  = await userRepository.signIn();

    isSuccessful = false;
    notifyListeners();
  }

  }
