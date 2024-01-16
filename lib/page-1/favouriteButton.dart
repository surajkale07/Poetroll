import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteButton extends StatefulWidget {
  final String poemId;
  final bool isEnabled;


  FavoriteButton({required this.poemId, required this.isEnabled});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;
  String? usertoken;



  @override
  void initState() {
    super.initState();
    // Load the initial favorite status from local storage
    loadFavoriteStatus();
    getuser();
  }
  Future<void> getuser()  async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usertoken= prefs.getString("usertoken");
    });
  }

  void checkforlogin(){
    Navigator.pushNamed(context, '/login');
    ScaffoldMessenger.of(
        context)
        .showSnackBar(const SnackBar(
      content: Text(
          "login to add Favourite"),
    ));
  }

  Future<void> loadFavoriteStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load the favorite status for the current poemId
    setState(() {
      isFavorite = prefs.getBool(widget.poemId) ?? false;
    });
  }

  Future<void> saveFavoriteStatus(bool isFavorite) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the favorite status for the current poemId
    await prefs.setBool(widget.poemId, isFavorite);
  }


  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.yellow : null,
      ),
      onPressed:widget.isEnabled ? () {
        // Toggle the favorite status when the button is pressed
        setState(() {
          isFavorite = !isFavorite;
        });
        saveFavoriteStatus(isFavorite);
        // Update the favorite status on the server
        updateFavoriteStatus(widget.poemId, isFavorite);
      }
      :checkforlogin,
    );
  }

  Future<void> updateFavoriteStatus(String poemId, bool isFavorite) async {
    final client = http.Client();

    try {
      final url=Uri.parse('https://www.poetroll.com/webservices/add-favourite-unfavourite-poem.php?');
      final response = await client.post(
          url.replace(queryParameters: {
            'user_token': usertoken,
            'poem_id': poemId,
            'response': isFavorite ? "1" : "0",
          }),
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['status'] == 'Success!') {
          // Handle the success status
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isFavorite ? 'Added to favorites' : 'Removed from favorites',
              ),
            ),
          );
        } else {
          // Handle other statuses or errors
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update favorite status'),
            ),
          );
        }
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite status. Status code: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      print('Error updating favorite status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating favorite status'),
        ),
      );
    }
  }
}
