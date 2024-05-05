import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_6/app/ui/pages/home/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProvider<homecontroller>(
      create: (_) => homecontroller(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Consumer<homecontroller>(
            builder: (_, controller, __) {
              return Text("Hola, ${controller.Firstname} ${controller.Lastname} ");
            },
          ),
        ),
        body: Selector<homecontroller, bool> (
          selector: (_, controller) => controller.loading,
          builder: (context, loading, loadingWidget) {
            if(loading){
              return loadingWidget!;
            }
    return Consumer<homecontroller>(
      builder: (_, controller, gpsenable){ 
         
        if (!controller.gpsenabled){
         return gpsenable!;
        }
        return GoogleMap(
        onMapCreated: controller.onMapCreated,
        initialCameraPosition: controller.initialCameraPosition,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: false,
        zoomControlsEnabled: false,
        markers: {
       Marker(
         markerId: MarkerId('Sydney'),
         position: LatLng(controller.latitude as double, controller.longitude as double),
      )
   },
    );
      },
       child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("to use our app we need acces to your location, "),
                ElevatedButton(
                  onPressed: () {
                    final controller =context.read<homecontroller>();
                    controller.turnOnGPS();

                  }, 
                  child: Text('Turn on gps'),
                  ),
              ],
            ),
          ),
    );
          },
          child: const Center(child: CircularProgressIndicator(),),
        ),
    ),
    );
  }
  
}
