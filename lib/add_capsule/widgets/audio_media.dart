import 'package:app/add_capsule/add_capsule_bloc/add_capsule_bloc.dart';
import 'package:app/add_capsule/add_capsule_bloc/add_capsule_model.dart';
import 'package:app/add_capsule/widgets/audio_player.dart';
import 'package:app/add_capsule/widgets/audio_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as ap;
class AudioMedia extends StatefulWidget {
  const AudioMedia({Key? key}) : super(key: key);

  @override
  _AudioMediaState createState() => _AudioMediaState();
}

class _AudioMediaState extends State<AudioMedia> {
  bool showPlayer = false;
  String audioPath = "";
  ap.AudioSource? audioSource;
  @override
  void initState() {
    showPlayer = false;
    String type = context.read<AddCapsuleBloc>().media.type;
    print("Type: $type");
    if (type == "Audio") {
      audioPath = context.read<AddCapsuleBloc>().media.path;
    }
    if (audioPath != "") {
      audioSource = ap.AudioSource.uri(Uri.parse(audioPath));
      showPlayer = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: showPlayer
            ? Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: AudioPlayer(
                      
                      )),
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
                          setState(() {
                            showPlayer = false;
                          });
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
                            showPlayer = false;
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
            : Column(
                children: [
                  AudioRecorder(
                    onStop: (String path) {
                      setState(() {
                        audioSource = ap.AudioSource.uri(Uri.parse(path));
                        audioPath = path;
                        showPlayer = true;
                      });
                      context.read<AddCapsuleBloc>().add(
                          AddCapsuleUpdateMediaIconBtnEvent(
                              CapsuleMedia(type: "Audio", path: audioPath)));
                    },
                  ),
                ],
              ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showPlayer', showPlayer));
    properties
        .add(DiagnosticsProperty<ap.AudioSource?>('audioSource', audioSource));
  }


}

