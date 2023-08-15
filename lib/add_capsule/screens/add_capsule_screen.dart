import 'dart:developer';

import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';

import 'package:app/add_capsule/widgets/capsule_location_button.dart';
import 'package:app/add_capsule/widgets/capsule_member_button.dart';
import 'package:app/add_capsule/widgets/capsule_schedule_picker.dart';
import 'package:app/add_capsule/widgets/capsule_visibility_dropdown.dart';
import 'package:app/add_capsule/widgets/media_icon_button.dart';
import 'package:app/app/grafbase_cubit/grafbase_repo.dart';
import 'package:app/app/supabase_bloc/supabase_auth_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCapsuleScreen extends StatelessWidget {
  AddCapsuleScreen({super.key});
  final AddCapsuleBloc addCapsuleBloc = AddCapsuleBloc();
  TextEditingController _captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              final cron = addCapsuleBloc.cron;
              final expiresAt = addCapsuleBloc.expiresAt;

              print(cron);
              print(expiresAt);

              try {
                String publicUrl = await addCapsuleBloc
                    .uploadImageToSupabase(addCapsuleBloc.media.path);
                print("publicUrl $publicUrl");

                // context
                //     .read<SupabaseBloc>()
                //     .add(PictureUploadCompleteEvent(publicUrl));

                final accessToken = SupabaseAuth().getJWT();
                print(accessToken);

                // return;
                final sub = SupabaseAuth().getSub();

                final capsule = addCapsuleBloc.generateCapsule();

                await GrafbaseRepo().createCapsule(accessToken, sub, capsule);

                // Snackbar to show success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Capsule scheduled!"),
                    backgroundColor: Colors.green,
                  ),
                );

                // clear the caption
                _captionController.clear();
                // clear media
                addCapsuleBloc.clearCapsuleLocation();

                addCapsuleBloc.clearCapsuleMedia();

                addCapsuleBloc.clearCapsulePeople();
                
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Something went wrong, Please try again later"),
                    backgroundColor: Colors.red,
                  ),
                );
                log("Error in creating capsule | $e");
                rethrow;
              }
            },
            child: const Text("Post", style: TextStyle(color: Colors.white)),
          )
        ],
        // back button

        title: const Text('Add Capsule'),
      ),
      body: BlocProvider.value(
        value: addCapsuleBloc,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  addCapsuleBloc.caption = value;
                },
                controller: _captionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    filled: true,
                    hintText: "Write your caption here",
                    fillColor: const Color(0xff293138),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Color(0xffA4A6A8))),
                maxLines: 10,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                MediaIconButton(),
                const SizedBox(width: 10),
                const CapsuleMemberButton(),
                const SizedBox(width: 10),
                const CapsuleLocationButton(),
                const SizedBox(width: 10),
                CapsuleSchedulePicker()
              ],
            )
          ],
        ),
      ),
    );
  }
}
