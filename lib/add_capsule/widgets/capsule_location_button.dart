
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/add_capsule/screens/select_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CapsuleLocationButton extends StatelessWidget {
  const CapsuleLocationButton({
    super.key,
   
  });

  

  @override
  Widget build(BuildContext context) {
    AddCapsuleBloc addCapsuleBloc = context.read<AddCapsuleBloc>();
    CapsuleLocation location = context.watch<AddCapsuleBloc>().location;
    return CircleAvatar(
      radius: 23,
      backgroundColor: Color(0xff293138),
      child: IconButton(
        icon: location.address == ""
            ? Icon(Icons.location_disabled, color: Colors.blueGrey)
            : Icon(
                Icons.location_on,
                color: Color.fromARGB(255, 99, 108, 235),
              ),
        // Text("0",
        //     style: TextStyle(color: Colors.white, fontSize: 18)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
              value: addCapsuleBloc,
              child: SelectLocationScreen(),
            );
          }));
        },
      ),
    );
  }
}
