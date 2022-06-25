import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_training/toaste.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    locationPermission();
  }

  Position? x;

  Future <void>locationPermission() async {
    LocationPermission per;
    per = await Geolocator.checkPermission();
    print('=====================================');
    print(per);
    print('=====================================');
    if (per == LocationPermission.denied) {
      per = await Geolocator.requestPermission();
    }
    print(per);

    if (per == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('please allow access to your location'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      ));
    } else {
      bool isServiceEnabled;
      isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      print(isServiceEnabled);
      if (isServiceEnabled) {

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('please enable gps'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ));
      }
    }
  }

  Future<Position> getcl() async {
    x=await Geolocator.getCurrentPosition();
    print(x.toString());
    return await Geolocator.getCurrentPosition();
  }

  Completer<GoogleMapController> _controller = Completer();
  late Set<Marker> markers = {Marker(markerId: MarkerId('1'),position: LatLng(x!.latitude,x!.longitude))};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
      ),
      body: Column(
        children: [
          Center(
            child: MaterialButton(
                onPressed: ()  async{
                  x=await getcl();
                 setState((){

                 });

                  // print(Geolocator.distanceBetween(30, 30, 40, 40));
                },
                child: Text('Training')),
          ),
          x?.longitude != null
              ? Container(
                  height: 300,
                  width: 300,
                  child: GoogleMap(
                    markers: markers,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(x!.latitude, x!.longitude), zoom: 14),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }
}

//AIzaSyDS9hDyHmBYEm7ZSAHDJgpR3S3qAZw8xTI
