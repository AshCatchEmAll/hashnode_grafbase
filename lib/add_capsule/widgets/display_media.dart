
import 'package:app/add_capsule/widgets/audio_media.dart';
import 'package:app/add_capsule/widgets/video_media.dart';
import 'package:flutter/material.dart';

import 'image_media.dart';

class DisplayMedia extends StatefulWidget {
  DisplayMedia(
      {Key? key, required this.mediaType, this.imagePath, this.videoPath})
      : super(key: key);
  final String mediaType;
  final String? imagePath;
  final String? videoPath;
  @override
  State<DisplayMedia> createState() => _DisplayMediaState();
}

class _DisplayMediaState extends State<DisplayMedia> {
  @override
  Widget build(BuildContext context) {
    if (widget.mediaType == "Image") {
      return ImageMedia();
    } else if (widget.mediaType == "Video") {
      return VideoMedia();
    } else if (widget.mediaType == "Audio") {
      return AudioMedia();
    }

    return Container(
      child: Text("No media selected", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 76, 89, 101))),
    );
  }
}

