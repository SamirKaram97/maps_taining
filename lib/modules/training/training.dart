import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_training/toaste.dart';
import 'package:geocoding/geocoding.dart';


class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {

  Position? x;

  Future getLocation()async
  {
    LocationPermission per;
    per=await Geolocator.checkPermission();
    print('=====================================');
    print(per);
    print('=====================================');
    if(per== LocationPermission.denied)
      {
        per=await Geolocator.requestPermission();
      }
    print(per);

    if(per== LocationPermission.denied)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('please allow access to your location'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            ));
    }
    else
      {
        bool isServiceEnabled;
        isServiceEnabled=await Geolocator.isLocationServiceEnabled();
        print(isServiceEnabled);
        if(isServiceEnabled)
          {
            x=await getcl();
          }
        else
          {
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
  Future<Position> getcl()async
  {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training'),),
      body: Center(child: MaterialButton(onPressed:()async{
        await getLocation();
        print(x!.longitude);
        print(x!.latitude);
        List<Placemark> placemarks = await placemarkFromCoordinates(x!.longitude, x!.latitude);
        print(placemarks[0]);
      },child: Text('Training')),),
    );
  }
}
