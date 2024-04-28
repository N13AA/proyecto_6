import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_6/app/ui/pages/home/home_controller.dart';
class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
  
    return ChangeNotifierProvider<homecontroller>(
      create: (_)=>homecontroller(), 
      child: Scaffold(
        appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
  
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
