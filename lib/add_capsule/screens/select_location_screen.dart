import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SelectLocationScreen extends StatefulWidget {
  SelectLocationScreen({Key? key}) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff126EAB)),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text("Done", style: TextStyle(color: Colors.white)),
            )
          ],
          // back button

          title: const Text('Select Media'),
        ),
        body: dotenv.env['google_api_key'] != null
            ? MapLocationPicker(
                hideBackButton: true,
                currentLatLng: context.read<AddCapsuleBloc>().location.address ==
                        ""
                    ?  const LatLng(28.8993468, 76.6250249)
                    : context
                        .read<AddCapsuleBloc>()
                        .location
                        .latLng, //LatLng
               
                mapType: MapType.hybrid,
                bottomCardIcon: Icon(Icons.send, color: Color(0xff3179B7)),
                
                onDecodeAddress: (GeocodingResult? result) {
                  print("lattiude is ${result?.geometry.location.lat}");
                  print("longitude is ${result?.geometry.location.lng}");
                  if (result == null) return;
                  context
                      .read<AddCapsuleBloc>()
                      .add(AddCapsuleUpdateLocationEvent(CapsuleLocation(
                        address: result.formattedAddress ?? "",
                        latLng: LatLng(result.geometry.location.lat,
                            result.geometry.location.lng),
                      )));
                },
                onSuggestionSelected: (PlacesDetailsResponse? result) {
                  if (result == null) return;
                  if (result.result.geometry?.location == null) return;

                
                  context
                      .read<AddCapsuleBloc>()
                      .add(AddCapsuleUpdateLocationEvent(CapsuleLocation(
                        address: result.result.formattedAddress ?? "",
                        latLng: LatLng(result.result.geometry!.location.lat,
                            result.result.geometry!.location.lng),
                      )));
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Location set to ${result.result.formattedAddress  ?? ""}"),
                      duration: Duration(seconds: 4),
                    ),
                  );
                },
                apiKey: dotenv.env['google_api_key']!,
                hideBottomCard: true,
               
                hideSuggestionsOnKeyboardHide: true,
              )
            : const Center(
                child: Text("Please add a google api key to .env"),
              ));
  }
}
