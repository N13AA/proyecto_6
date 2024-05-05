import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class homecontroller extends ChangeNotifier {
  final Map <MarkerId, Marker> _markers = {};
  Set <Marker> get markers => _markers.values.toSet();
  bool _loading = true; 
 bool get loading => _loading;
late bool _gpsenabled;
bool get gpsenabled => _gpsenabled;
StreamSubscription? _gpssubscription, _positionsubscription;
   Position? _initialposition;
     Position? _ubi;
       Position? newUbi ;
        double? latitude;
         double? longitude;
         String? Firstname;
          String? Lastname;
CameraPosition get initialCameraPosition => CameraPosition(target: LatLng(
            _initialposition!.latitude, 
          _initialposition!.longitude),
          zoom: 16);


  void onMapCreated(GoogleMapController controller){
  
}



homecontroller(){
  _init();
loadIdFromSharedPreferences();

}
Future<void> loadIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    print ("$id");
     final url = Uri.parse('http://192.168.0.174:8080/location/$id'); 
final response = await http.get(url);
 final Data = jsonDecode(response.body.toString());
    Firstname = Data['FirstName'];
     Lastname = Data['LastName'];
  }
Future <void> turnOnGPS() => Geolocator.openLocationSettings();

 Future<void> _init()async{
     final url = Uri.parse('http://192.168.0.174:8080/location'); 
final res = await http.get(url);
 final Data = jsonDecode(res.body.toString());
    latitude = Data['latitude'];
     longitude = Data['longitude'];
    
 _gpsenabled = await Geolocator.isLocationServiceEnabled();
  _loading= false;
 _gpssubscription=Geolocator.getServiceStatusStream().listen(
    (status) async {
      _gpsenabled = status == ServiceStatus.enabled;
     //await _getposition();
     if(_gpsenabled){
      _initlocationupdates();
     }
    },
    );
  _initlocationupdates();
 }
 Future <void> _initlocationupdates()async{
  bool initialized = false;
  await _positionsubscription?.cancel();
  _positionsubscription = Geolocator.getPositionStream().listen((Position) {
if (!initialized)
{
    _getposition(Position);
initialized = true;
notifyListeners();
}

  },
  onError: (e){
if (e is LocationServiceDisabledException){
  _gpsenabled = false;
  notifyListeners();
}
  }
  );
 }
Future <void> _getposition(Position Position)async {
 if(_gpsenabled && _initialposition == null){
  _initialposition = Position;
  final url = Uri.parse('http://192.168.0.174:8080/location'); 
    final positionString = "${_initialposition!.latitude},${_initialposition!.longitude}";
     final positionjson = jsonEncode(positionString);
     final headers = {'Content-Type': 'application/json'};
     final response = await http.post(url, headers: headers, body: positionjson);
      }
 }
@override
  void dispose() {
    _positionsubscription?.cancel();
 _gpssubscription?.cancel() ;
    super.dispose();
  }
}
