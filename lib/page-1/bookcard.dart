import 'package:flutter/material.dart';

import 'bookpdfViewer.dart';

class Bookcard extends StatelessWidget{

  final String bookimg;
  final String title, bookurl;

  const Bookcard({ required this.bookimg, required this.title, required this.bookurl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerPage(pdfUrl: bookurl, title: title),
            ),
          );
        },
        child: Card(
          elevation: 2,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    bookimg,
                    fit: BoxFit.fill,
                    height: 250,
                    width: double.infinity,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
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
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}