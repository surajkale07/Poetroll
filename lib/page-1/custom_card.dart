import 'package:flutter/material.dart';
import 'package:myapp/page-1/poem_player.dart';

class CustomCard extends StatelessWidget {
  final String backgroundImage;
  final String title;
  final String poem_id;
  final String authorname;



  CustomCard({
    required this.backgroundImage,
    required this.title, required this.poem_id, required this.authorname,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Poemplayer(
              poem_id: poem_id,
              title: title,
              authorname: authorname,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent, // Set the color of the Card to transparent
        child: SizedBox(
          width: 100, // Adjust the width as needed
          height: 160, // Increase the height to fit the content
          child: Column(
            children: [
              // Image
              ClipRRect(
            borderRadius: BorderRadius.circular(10),
              child: Image.network(
                backgroundImage,
                fit: BoxFit.cover,
                height: 120,
                width: double.infinity,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  // Handle the error by returning a placeholder or default image
                  return Image.asset(
                    'assets/page-1/images/noimg.jpg',
                    // Replace with your default image asset path
                    fit: BoxFit.fill,
                    height: 120,
                    width: double.infinity,
                  );
                },
              )),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  color: Colors.transparent, // Set the color to transparent
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        "Sohan Roy",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
