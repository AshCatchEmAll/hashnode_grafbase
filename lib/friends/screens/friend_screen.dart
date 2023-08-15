import 'package:app/friends/widgets/friend_item.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff717171)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Discover Friends'),
      ),

      body: Column(children: [
         SizedBox(height: 20,),
          SearchBar(),

          SizedBox(height: 20,),

          Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom:8.0),
                  child: FriendItem());
              },
            ),
          ),

      ],)
    );

  }
}