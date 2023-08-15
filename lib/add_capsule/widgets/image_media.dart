
import 'dart:io';

import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImageMedia extends StatefulWidget {
  const ImageMedia({super.key});

  @override
  State<ImageMedia> createState() => _ImageMediaState();
}

class _ImageMediaState extends State<ImageMedia> {
  String _imagePath = "";

  @override
  void initState() {
    super.initState();
    String type = context.read<AddCapsuleBloc>().media.type;

    print("FROM IMAGE MEDIA : $type");
    if (type == "Image") {
      _imagePath = context.read<AddCapsuleBloc>().media.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imagePath == ""
            ? ElevatedButton(
                onPressed: () async {
                  await handleOnpressed();
                },
                child: Text("Select Image"))
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.file(
                    File(_imagePath),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff242641)),
                        ),
                        onPressed: () async {
                          await handleOnpressed();
                        },
                        child: Text("Select Again",
                            style: TextStyle(color: Colors.white))),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff242641)),
                        ),
                        onPressed: () {
                          setState(() {
                            _imagePath = "";
                          });

                          context.read<AddCapsuleBloc>().clearCapsuleMedia();
                        },
                        icon: const Icon(
                          Icons.cancel_rounded,
                          color: Color.fromARGB(255, 77, 118, 146),
                        ))
                  ]),
                ],
              )
      ],
    );
  }

  handleOnpressed() async {
    final imagePath = await selectImage();

    if(imagePath == "") return;
    setState(() {
      _imagePath = imagePath.toString();
    });

    final size = await File(_imagePath).length();

    if (size > 10000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Image size must be less than 10MB"),
        ),
      );
      return null;
    }
    context.read<AddCapsuleBloc>().add(AddCapsuleUpdateMediaIconBtnEvent(
        CapsuleMedia(type: "Image", path: _imagePath)));
  }

  Future<String> selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return "";

    final File imageFile = File(pickedFile.path);

    final String fileExtension = imageFile.path.split('.').last;
    return pickedFile.path;

  
  }
}

