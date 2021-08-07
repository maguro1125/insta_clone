import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:insta_clone/data_model/location.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/view_models/post_view_model.dart';
import 'package:provider/provider.dart';



class MapScreen extends StatefulWidget {

  final Location location;

  MapScreen({required this.location});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late LatLng _latLng ;//宣言をする
  late CameraPosition _cameraPosition;//宣言をする
  GoogleMapController? _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};//

  @override
  //initStateメソッドで設定
  void initState() {
    _latLng = LatLng(widget.location.latitude, widget.location.longitude);//locationを宣言したものに入れている
    _cameraPosition = CameraPosition(target: _latLng, zoom: 20.0);//↑と同じ
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectPlace),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            //TODO
            onPressed: () =>  _onPlaceSelected(),
          )
        ],
      ),
      //地図表示
      body: GoogleMap(
        initialCameraPosition: _cameraPosition,//これをinitStateで設定
        onMapCreated: onMapCreated,
        onTap: onMapTapped,
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onMapTapped(LatLng latLng) {
    print("selected: $_latLng");
    _latLng = latLng;
    _createMarker(_latLng);
  }

  void _createMarker(LatLng latLng) {
    final markerId = MarkerId("selected");
    final marker = Marker(markerId: markerId, position: latLng);
    setState(() {
      _markers[markerId] = marker;
    });
  }

  _onPlaceSelected() async{
    final postViewModel = Provider.of<PostViewModel>(context,listen: false);
    await postViewModel.updateLocation(_latLng.latitude, _latLng.longitude);
    Navigator.pop(context);
  }
}
