import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff1B272F),
      child: ListTile(
        
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            'https://picsum.photos/250?image=9',
            width: 50,
            height: 50,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Friend Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Email',
              style: TextStyle(
                color: Color(0xffD1E4F2),
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Row(
          
          mainAxisSize: MainAxisSize.min,
          children: [
             CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xff293138),
                child: IconButton(
                  
                  icon: Icon(Icons.add_circle_rounded, color: Color(0xff6D7C89)),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 10,),
           CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xff293138),
                child: IconButton(
                  icon: Icon(Icons.visibility_rounded, color: Color(0xff3179B7)),
                  onPressed: () {},
                ),
              ),
              

        ],)
      ),
    );
  }
}
