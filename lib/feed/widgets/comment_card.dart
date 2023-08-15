import 'package:app/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.96,
      child: Card(
        color: MemoraColors.commentCardBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
               
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        "https://picsum.photos/200/200",
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Jane Smith",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            Text("2w ago",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                       
                          SizedBox(height: 10),
                           Text("LOrem ipsur adi jahsgdhjasgd jhagsd"),
                    
                        SizedBox(height: 10),
                        Row(
               
                          
                          children: [
                            Icon(CupertinoIcons.heart),
   SizedBox(width: 10),
                            Text("50+"),
                             SizedBox(width: 10),
                            Container(
                              height: 30,
                              width: 120,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "View Thread",
                                    style: TextStyle(fontSize: 10),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



