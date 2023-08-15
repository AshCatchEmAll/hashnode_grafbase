import 'dart:math';

import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/app/grafbase_cubit/grafbase_repo.dart';
import 'package:app/app/supabase_bloc/supabase_auth_repo.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:map_location_picker/map_location_picker.dart';

class CapsuleCard extends StatefulWidget {
  const CapsuleCard({
    super.key,
    required this.capsule,
  });
  final Capsule capsule;

  @override
  State<CapsuleCard> createState() => _CapsuleCardState();
}

class _CapsuleCardState extends State<CapsuleCard> {
   late ConfettiController _controllerCenter;


   @override
   void initState() {
     super.initState();
      _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
   }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Color(0xff1B272F),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(children: [
            ConfettiWidget(
              confettiController: _controllerCenter,

              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              // createParticlePath: drawStar, // define a custom shape/path.
            ),
            Row(
              children: [
                Icon(Icons.schedule_rounded, color: Colors.white, size: 26),
                SizedBox(width: 10),
                Text(formatDate(widget.capsule.availableAt),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))
              ],
            ),
            //Capsule location
            SizedBox(height: 10),
            // capsule.location == null ? Container() :
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 26),
                SizedBox(width: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      displayLocation(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ))
              ],
            ),

            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.people, color: Colors.white, size: 26),
                SizedBox(width: 10),
                Text(widget.capsule.members.length.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))
              ],
            ),

            //Have a linear bar which shows how far the availableAt time is from createdAt
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                    isCapsuleAvailable() == false
                        ? Icons.lock_rounded
                        : Icons.lock_open_rounded,
                    color: isCapsuleAvailable() == false
                        ? Colors.blueGrey
                        : Colors.white,
                    size: 26),
                SizedBox(width: 10),
                // Elevated Button
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCapsuleAvailable() == false
                          ? Color(0xff161728)
                          : Color.fromARGB(255, 99, 145, 185),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    onPressed: isCapsuleAvailable() == false
                        ? () {}
                        : () async {
                            await openCapsule(context);
                          },
                    child: Text(
                      isCapsuleAvailable() == false ? "Locked" : "Open Capsule",
                      style: TextStyle(
                          color: isCapsuleAvailable() == false
                              ? Colors.blueGrey
                              : Color(0xff1B272F),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ]),
        ),
      ),
    );
  }

  openCapsule(BuildContext context) async {
    try {
        

       
   
      // check if capsule is available
      // if not, show a snackbar
      final accessToken = SupabaseAuth().getJWT();
      print("takasl");
      if (DateTime.now().isBefore(widget.capsule.availableAt)) {
        print("1");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 231, 92, 82),
            content: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("This capsule is not available yet",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        );
        return;
      }
      print("takasl2");
      final userLocation = await fetchUserLocation();
      print("Ir eng.");
      print(widget.capsule.location?.latLng);
      print("User location");
      print(userLocation);
     
      if (widget.capsule.location != null && !(widget.capsule.location!.isZero)) {
        final capsuleLocation = LatLng(widget.capsule.location!.latLng.latitude,
            widget.capsule.location!.latLng.longitude);

        if (getLatLngDistance(userLocation, capsuleLocation) > 50) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 231, 92, 82),
              content: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("You are too far away from the capsule",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          );
          return;
        }
      }
     
      await GrafbaseRepo().unlockCapsule(widget.capsule.id!, accessToken,
          userLocation.latitude, userLocation.latitude);
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 58, 115, 49),
              content: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Capsule unlocked 🎉",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          );
        _controllerCenter.play();

        Future.delayed(Duration(seconds: 1), () {
          _controllerCenter.stop();
        });
    } catch (e) {
      print(e);
    }
  }

  getLatLngDistance(LatLng userLocation, LatLng capsuleLocation) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((capsuleLocation.latitude - userLocation.latitude) * p) / 2 +
        c(userLocation.latitude * p) *
            c(capsuleLocation.latitude * p) *
            (1 - c((capsuleLocation.longitude - userLocation.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  Future<LatLng> fetchUserLocation() async {
    try {
      loc.Location location = new loc.Location();

      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;
      loc.LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw Exception("Location service not enabled");
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          throw Exception("Location permission not granted");
        }
      }

      _locationData = await location.getLocation();
      if (_locationData.latitude == null || _locationData.longitude == null) {
        throw Exception("Location not found");
      }
      return LatLng(_locationData.latitude!, _locationData.longitude!);
    } catch (e) {
      print(e);
      throw Exception("Location not found");
    }
  }

  displayLocation() {
    if (widget.capsule.location == null || widget.capsule.location?.address == "") {
      return "Any";
    } else {
      return widget.capsule.location?.address;
    }
  }

  bool isCapsuleAvailable() {

    return widget.capsule.availableAt.isBefore(DateTime.now());
  }

  formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd HH:mm').format(date);
  }
}
