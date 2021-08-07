import 'dart:io';
import 'package:flutter/material.dart';
import 'package:insta_clone/data_model/location.dart';
import 'package:insta_clone/models/repositories/post_repository.dart';
import 'package:insta_clone/models/repositories/user_repository.dart';
import 'package:insta_clone/utils/constant.dart';

class PostViewModel extends ChangeNotifier{

  final UserRepository userRepository;
  final PostRepository postRepository;
  PostViewModel({required this.userRepository, required this.postRepository});

  File? imageFile;

  Location? location;

  //文字で位置情報を表示
  String locationString = "";

  String caption = "";

  //画像が取って来れたかどうか
  bool isProcessing = false;
  bool isImagePicked = false;

  //ファイルを持ってくる
  Future<void>pickImage(UploadType uploadType) async{
    isImagePicked = false;
    isProcessing = true;
    notifyListeners();

   imageFile  =  await postRepository.pickImage(uploadType);
   print("pickedImage: ${imageFile!.path}");

   // 位置情報
    location = await postRepository.getCurrentLocation();
    locationString = (location != null) ? _toLocationString(location!) : "";

    print("location: $locationString");

    if (imageFile != null)
      isImagePicked = true;
    isProcessing = false;
      notifyListeners();

    //画像取得のためのimage_picker


  }

  //表示にため一つの文字列に変換
  String _toLocationString(Location location) {
    return location.country + " " + location.state + " " + location.city;

  }

  Future<void>updateLocation(double latitude, double longitude) async{
    location = await postRepository.updateLocation(latitude, longitude);
    locationString =  (location != null) ? _toLocationString(location!) : "";
    notifyListeners();
  }


  //repoに外注処理
  Future<void>post() async{
    //[Null-Safety] imageFileがNullのときは早期リターンさせる
    if (imageFile == null) return;
    isProcessing = true;
    notifyListeners();

    await postRepository.post(
      UserRepository.currentUser!,
      imageFile!,
      caption,
      location,
      locationString
    );//repoに渡す値

    isProcessing = false;
    isImagePicked = false;
    notifyListeners();
  }

   void cancelPost() {
    isProcessing = false;
    isImagePicked = false;
    notifyListeners();
  }

}