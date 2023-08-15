import 'package:app/app/grafbase_cubit/grafbase_repo.dart';
import 'package:app/app/supabase_bloc/supabase_auth_repo.dart';
import 'package:app/feed/widgets/comment_card.dart';
import 'package:app/feed/widgets/post_card.dart';
import 'package:flutter/material.dart';

import '../../app/grafbase_cubit/grafbase_model.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post> posts = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final accessToken = SupabaseAuth().getJWT();

      final sub = SupabaseAuth().getSub();

      posts =  await GrafbaseRepo().getFeed(accessToken, sub);

      setState(() {
        
      });
      print(posts);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        title: const Text('Feed'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            posts.isEmpty ?  const Padding(
                    padding:  EdgeInsets.only(top: 18.0),
                    child:  Center(
                      child: Text(
                        "No Posts yet",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ):const SizedBox.shrink(),

            ...posts.map((post) => PostCard(post: post)).toList(),
            const SizedBox(height: 20),
           
            // CommentCard()
          ],
        ),
      ),
    );
  }
}
