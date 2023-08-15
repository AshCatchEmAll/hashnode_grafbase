import 'package:app/add_capsule/widgets/audio_player.dart';
import 'package:app/add_capsule/widgets/video_player.dart';
import 'package:app/app/grafbase_cubit/grafbase_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          displayAsset(),
          const SizedBox(
            height: 10,
          ),
          Text(
            post.caption,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  displayAsset() {
    if (post.content.contains('aac')) {
      print("HERE : ${post.content}");
      return AudioPlayer(
        audioPath: post.content,
      );
    }
    if (post.content.contains('mp4')) {
      return VideoPlayerWidget(
        videoPath: post.content,
      );
    } else {
      return Image.network(post.content);
    }
  }
}
