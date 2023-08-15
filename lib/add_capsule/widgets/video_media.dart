import 'dart:io';

import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/add_capsule/widgets/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoMedia extends StatefulWidget {
  const VideoMedia({super.key});

  @override
  State<VideoMedia> createState() => _VideoMediaState();
}

class _VideoMediaState extends State<VideoMedia> {
  String _videoPath = "";

  @override
  void initState() {
    super.initState();
    String type = context.read<AddCapsuleBloc>().media.type;
    if (type == "Video") {
      _videoPath = context.read<AddCapsuleBloc>().media.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _videoPath == ""
            ? ElevatedButton(
                onPressed: () async {
                  await handleOnpressed();
                },
                child: Text("Select Video"))
            : Container(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    child: VideoPlayerWidget(
                      videoPath: _videoPath,
                    ),
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
                            _videoPath = "";
                          });
                          context.read<AddCapsuleBloc>().clearCapsuleMedia();
                        },
                        icon: Icon(
                          Icons.cancel_rounded,
                          color: Color.fromARGB(255, 77, 118, 146),
                        ))
                  ]),
                ],
              )),
      ],
    );
  }

  handleOnpressed() async {
    final videoPath = await selectVideo();
    setState(() {
      _videoPath = videoPath.toString();
    });
    context.read<AddCapsuleBloc>().add(AddCapsuleUpdateMediaIconBtnEvent(
        CapsuleMedia(type: "Video", path: _videoPath)));
  }

  Future<String?> selectVideo() async {
    // Get download directory path

    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result == null) return "";
    final path = result.files.single.path;

    // check size of file
    final file = File(path!);
    final size = await file.length();
    // if (size > 10000000) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("File size must be less than 10MB"),
    //     ),
    //   );
    //   return "";
    // }

    return path;
  }

  getExternalStorageDirectory() {}
}

