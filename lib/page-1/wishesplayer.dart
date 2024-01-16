import 'dart:convert';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'favouriteButton.dart';
import 'likebutton.dart';


class Wishplayer extends StatefulWidget {
  final String poem_id;
  final String title;
  final String video_url;

  Wishplayer({
    required this.poem_id,
    required this.title, required this.video_url,
  });

  @override
  _WishplayerState createState() => _WishplayerState();
}

class _WishplayerState extends State<Wishplayer> {
  late CustomVideoPlayerController _customVideoPlayerController;
  String? name;

  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
    getuser();

  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  Future<void> getuser() async {
    final _auth = FirebaseAuth.instance;
    dynamic user;
    String userEmail;
    // String userPhoneNumber;
    user = _auth.currentUser;
    userEmail = user.email;
    final CollectionReference collectionReference = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await collectionReference.where('email', isEqualTo: userEmail).get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    for (int i = 0; i < documents.length; i++) {
      setState(() {
        name = documents[i].get('full_name'); // Assign the name to the variable
      });
    }}

  Future<List<Map<String, dynamic>>?> fetchComments(String poemId) async {
    final response = await http.get(Uri.parse('https://www.poetroll.com/webservices/list-comment.php?poem_id=$poemId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic> && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return null;
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
            ],
          ),
        )
    );
  }


  void initializeVideoPlayer() {
    setState(() {
      isLoading = true;
    });

    final videoUri = '${widget.video_url}';

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
