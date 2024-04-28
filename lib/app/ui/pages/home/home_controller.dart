import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class homecontroller extends ChangeNotifier {
  bool _loading = true; 
 bool get loading => _loading;
late bool _gpsenabled;
bool get gpsenabled => _gpsenabled;

StreamSubscription? _gpssubscription, _positionsubscription;
   Position? _initialposition;
CameraPosition get initialCameraPosition => CameraPosition(target: LatLng(
            _initialposition!.latitude, 
          _initialposition!.longitude),
          zoom: 16);
  void onMapCreated(GoogleMapController controller){
  
}



homecontroller(){
  _init();

}

Future <void> turnOnGPS() => Geolocator.openLocationSettings();

 Future<void> _init()async{
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
void _getposition(Position Position) {
 if(_gpsenabled && _initialposition == null){
       _initialposition = Position;
      }
 }
@override
  void dispose() {
    _positionsubscription?.cancel();
 _gpssubscription?.cancel() ;
    super.dispose();
  }
}
