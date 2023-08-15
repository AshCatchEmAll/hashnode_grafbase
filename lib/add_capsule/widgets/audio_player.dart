import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as ap;

class AudioPlayer extends StatefulWidget {
  AudioPlayer({super.key, this.audioPath});
  String? audioPath;
  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final ap.AudioPlayer audioPlayer = ap.AudioPlayer();
  final audioPlayerState = ["stopped", "playing", "paused"];
  String currentState = "stopped";
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      audioPlayer.setLoopMode(ap.LoopMode.all);

      if (widget.audioPath == null) {
        final path = context.read<AddCapsuleBloc>().media.path;
        await audioPlayer.setFilePath(path);
        return;
      }

      if (widget.audioPath!.contains("https://")) {
        await audioPlayer.setUrl(widget.audioPath!);
      } else {
        await audioPlayer.setFilePath(widget.audioPath!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.play_arrow,
                color: currentState == "playing"
                    ? Color(0xff126EAB)
                    : Color(0xff6D7C89),
              ),
              onPressed: () async {
                if (audioPlayer.duration == audioPlayer.position) {
                  await audioPlayer.seek(Duration.zero);
                }
                setState(() {
                  currentState = "playing";
                });
                await audioPlayer.play();

                // if audio is finished playing completely then stop the audio
              },
            ),
            IconButton(
              icon: Icon(
                Icons.pause,
                color: currentState == "paused"
                    ? Color(0xff126EAB)
                    : Color(0xff6D7C89),
              ),
              onPressed: () async {
                setState(() {
                  currentState = "paused";
                });
                await audioPlayer.pause();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.stop,
                color: currentState == "stopped"
                    ? Color(0xff126EAB)
                    : Color(0xff6D7C89),
              ),
              onPressed: () async {
                setState(() {
                  currentState = "stopped";
                });
                await audioPlayer.stop();
                await audioPlayer.seek(Duration.zero);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
