import 'package:flutter/material.dart';
import 'package:myapp/page-1/poem_player.dart';

class SmallCard extends StatelessWidget {
  final String backgroundImage;
  final String title;
  // ignore: non_constant_identifier_names
  final String poem_id;
  final String authorname;

  SmallCard({
    required this.backgroundImage,
    required this.title,
    // ignore: non_constant_identifier_names
    required this.poem_id,
    required this.authorname,
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
                    )));
      },
      child: Card(
        elevation: 3,
        child: Column(
          children: [
            Image.network(backgroundImage,
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
                 errorBuilder: (BuildContext context,
                    Object error, StackTrace? stackTrace) {
              // Handle the error by returning a placeholder or default image
              return Image.asset(
                'assets/page-1/images/noimg.jpg',
                // Replace with your default image asset path
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              );
            }),

            // Title at the Bottom
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(5),
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
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
