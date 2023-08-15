import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';

import 'package:app/add_capsule/widgets/display_media.dart';
import 'package:app/add_capsule/widgets/radio_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectMediaScreen extends StatefulWidget {
  SelectMediaScreen({super.key});

  @override
  State<SelectMediaScreen> createState() => _SelectMediaScreenState();
}

class _SelectMediaScreenState extends State<SelectMediaScreen> {
  String _selectedMediaType = "Image";

  @override
  void initState() {
    super.initState();
    String type = context.read<AddCapsuleBloc>().media.type;
    if (type != "") {
      _selectedMediaType = type;
    }
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...context
                  .read<AddCapsuleBloc>()
                  .mediaType
                  .map((e) => RadioContainer(
                        text: e,
                        value: e,
                        groupValue: _selectedMediaType,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedMediaType = value;
                          });
                        },
                      ),),
            ],
          ),
          Transform.translate(
              //  center
              offset: const Offset(0, 150),
              child: DisplayMedia(mediaType: _selectedMediaType)),
        ],
      ),
    );
  }
}
