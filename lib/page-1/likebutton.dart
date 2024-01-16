import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LikeButton extends StatefulWidget {
  final String poemId;
  final bool isEnabled;


  LikeButton({required this.poemId, required this.isEnabled});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;


  @override
  void initState() {
    super.initState();
    loadLikeStatus();
  }

  void checkforlogin(){
    Navigator.pushNamed(context, '/login');
    ScaffoldMessenger.of(
        context)
        .showSnackBar(SnackBar(
      content: Text(
          "login to add Like"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : null,
      ),
      onPressed: widget.isEnabled ? () {
        // Toggle the like status when the button is pressed
        setState(() {
          isLiked = !isLiked;
        });
        saveLikeStatus();
      }
      :checkforlogin,
    );
  }



  // Load the initial like status from local storage
  Future<void> loadLikeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Use ?? false to default to false if the key doesn't exist
      isLiked = prefs.getBool('${widget.poemId}_like') ?? false;
    });
  }

  // Save the updated like status to local storage
  Future<void> saveLikeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.poemId}_like', isLiked);
  }
}
