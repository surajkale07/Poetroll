import 'dart:convert';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import 'custom_card.dart';
import 'favouriteButton.dart';
import 'likebutton.dart';

class Poemplayer extends StatefulWidget {
  final String poem_id;
  final String title;
  final String authorname;

  Poemplayer({
    required this.poem_id,
    required this.title,
    required this.authorname,
  });

  @override
  _PoemplayerState createState() => _PoemplayerState();
}

class _PoemplayerState extends State<Poemplayer> {
  late CustomVideoPlayerController _customVideoPlayerController;
  String? name;
  String? usertoken;
  String? userName;

  late bool isLoading = true;
  List<Map<String, dynamic>> poemData = [];

  bool followRedirects = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    getuser();
    fetchData2();
  }
  Future<void> getuser()  async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usertoken= prefs.getString("usertoken");
      userName= prefs.getString("name");

    });
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }


  Future<List<Map<String, dynamic>>?> fetchComments(String poemId) async {
    final response = await http.get(Uri.parse(
        'https://www.poetroll.com/webservices/list-comment.php?poem_id=$poemId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return null;
  }

  Future<void> fetchData2() async {
    final response = await http.get(Uri.parse(
        'https://www.poetroll.com/webservices/list-recent-most-view.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data']['recent_poems'] is List) {
        setState(() {
          poemData =
              List<Map<String, dynamic>>.from(data['data']['recent_poems']);
        });
      } else {
        print('Data is not in the expected format');
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color(0xff254ba0),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomVideoPlayer(
                      customVideoPlayerController: _customVideoPlayerController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildText(),
                    _buildLikeCommentShareButtons(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Sponserd By: ',
                                style: SafeGoogleFont('Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    height: 1.1725,
                                    letterSpacing: 0.0120000002,
                                    color: const Color(0xff1b1b1f)),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: 'Effism',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                  "assets/page-1/images/effism.jpg"),
                            )
                          ],
                        )),
                    Container(
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Similar Poems',
                              style: SafeGoogleFont(
                                'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                height: 1.1725,
                                letterSpacing: 0.0120000002,
                                color: const Color(0xff1b1b1f),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 10,crossAxisSpacing: 10),
                                child: Row(
                                  children: poemData.map((poem) {
                                    return InkWell(
                                      onTap: () {
                                        // Handle card tap
                                      },
                                      child: CustomCard(
                                        backgroundImage: poem['image_path'],
                                        title: poem['poem_name'],
                                        poem_id: poem['poem_id'],
                                        authorname: poem['author_name'],
                                      ),
                                    );
                                  }).toList(),
                                ))
                          ],
                        )),
                  ],
                ),
              ));
  }

  Widget _buildLikeCommentShareButtons() {

    final user =usertoken;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        LikeButton(poemId: widget.poem_id, isEnabled: user != null),
        FavoriteButton(poemId: widget.poem_id, isEnabled: user != null),
        IconButton(
          icon: Icon(Icons.comment),
          onPressed: () {
            _showCommentDialog(); // Pass the current context
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            final videoUrl =
                'https://poetroll.com/poetroll_api/uploads/poem_video/poem_${widget.poem_id}.mp4';
            _shareVideo(videoUrl);
          },
        ),
      ],
    );
  }

  Widget _buildText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColoredText("", "${widget.title}"),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildColoredText("Music Director: ", "Bijuram"),
            _buildColoredText("Artist: ", "Bijuram"),
          ],
        ),
        SizedBox(height: 10),
        _buildColoredText("Lyrics: ", "${widget.authorname}"),
      ],
    );
  }

  Widget _buildColoredText(String prefix, String text) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: prefix,
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: text,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> postComment(
      String userId, String poemId, String title, String description) async {
    final client = http.Client();

    try {
      final url = Uri.parse('http://poetroll.com/webservices/add_comment.php');
      final response = await client.post(
        url.replace(queryParameters: {
          'userid': userId,
          'poem_id': poemId,
          'title': title,
          'description': description,
        }),
        // You can customize headers if needed
        // headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 301 || response.statusCode == 302) {
        // Handle redirection if needed
        final newLocation = response.headers['location'];
        if (newLocation != null) {
          print('Redirected to: $newLocation');
          // Manually follow the redirection
          final redirectedResponse = await client.get(Uri.parse(newLocation));
          // Process the redirected response as needed
          print('Redirected response: ${redirectedResponse.body}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Comment Added"),
          ));
        } else {
          print('Redirection location header not found');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong try again"),
          ));
        }
      } else if (response.statusCode == 200) {
        // Comment posted successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Comment Added"),
        ));
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something went wrong try again"),
        ));
        print('Failed to post comment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  void _showCommentDialog() async {
    final token = usertoken;
    if (token == null) {
      // User is not authenticated, navigate to the login page
      Navigator.pushNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("login to add comment"),
      ));
      return;
    }

    final comments = await fetchComments('${widget.poem_id}');
    TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Comments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                  ),
                ],
              ),
              if (comments != null && comments.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    '${comment['Title']} . ${comment['Date']}'),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('${comment['Description']}'),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              else
                Text('No comments available'),
              // Show a message when there are no comments
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      postComment(usertoken!, widget.poem_id, userName!,
                          commentController.text);
                      Navigator.of(context)
                          .pop(); // Close the bottom sheet after posting the comment
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareVideo(String videoUrl) {
    Share.share(videoUrl);
  }

  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });

    final videoUrl =
        'https://poetroll.com/poetroll_api/uploads/poem_video/poem_${widget.poem_id}.mp4';
    final videoUri = Uri.parse(videoUrl);

    final _videoPlayerController = VideoPlayerController.network(
      videoUri.toString(),
    );

    _videoPlayerController.initialize().then((value) {
      setState(() {
        isLoading = false;
        _videoPlayerController.play();
      });
    });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }
}
