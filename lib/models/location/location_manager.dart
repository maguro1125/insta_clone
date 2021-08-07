import 'dart:async';

import 'package:geocoding/geocoding.dart'as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:insta_clone/data_model/location.dart';

//パッケージを使って位置情報を持ってくる、自分の作ったモデルクラスに変更する
class LocationManager{

  Future<Location>getCurrentLocation() async{
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    final placeMarks = await geocoding.placemarkFromCoordinates(position.latitude, position.longitude);
    final placeMark = placeMarks.first;
    return Future.value(convert(placeMark, position.latitude, position.longitude));
  }


  Future<Location>updateLocation(double latitude, double longitude) async{
    final placeMarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks.first;
    return Future.value(convert(placeMark, latitude, longitude));

  }



  //geocodingのplaceMarkクラスからデータクラスに変換
  Location convert(geocoding.Placemark placeMark, double latitude, double longitude) {
    return Location(
      latitude: latitude,//引数で持ってきている
      longitude: longitude,//引数で持ってきている
      country: placeMark.country ?? "",
      state: placeMark.administrativeArea ?? "",
      city: placeMark.locality ?? "",
    );
  }


}