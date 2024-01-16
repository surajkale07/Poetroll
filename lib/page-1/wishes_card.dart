import 'package:flutter/material.dart';
import 'package:myapp/page-1/wishesplayer.dart';

class WishesCard extends StatelessWidget {
  final ImageProvider backgroundImage;
  final String title;
  final String poem_id;
  final String video_url;

  WishesCard({
    required this.backgroundImage,
    required this.title, required this.poem_id, required this.video_url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Wishplayer(poem_id: poem_id, title: title, video_url: video_url,)));
    },
      child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 100, // Adjust the width as needed
        height: 200, // Increase the height to fit the content
        child: Column(
          children: [
            // Image
            Container(
              height: 180, // Adjust the height of the image as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                image: DecorationImage(
                  image: backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Play Button at the Center
            Expanded(
              child:Container(
                  padding: const EdgeInsets.all(5),
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,

                        ),

                      ]
                  )),
            ),
          ],
        ),
      ),
    ));
  }
}
