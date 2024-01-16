import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  List<Map<String, dynamic>> myPoems = [];
  bool isLoading = true;
  String? userEmail;
  String? userName;
  String? usertoken;
  Future<void> getuser()  async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName= prefs.getString("name");
      usertoken= prefs.getString("usertoken");
      userEmail= prefs.getString("email");
    });
  }


  @override
  void initState() {
    super.initState();
    getuser();
    fetchMyPoems();
  }


  Future<void> fetchMyPoems() async {
    final userToken = usertoken; // Replace with the actual user token
    final url = Uri.parse('https://www.poetroll.com/webservices/list-my_poem.php?user_token=$userToken');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['my_poems'] is List) {
          setState(() {
            myPoems = List<Map<String, dynamic>>.from(data['data']['my_poems']);
          });
        }
      } else {
        print('Failed to fetch my poems. Status code: ${response.statusCode}');
        setState(() {
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Profile"),
          ],
        ),
        backgroundColor: Colors.transparent,
        // Set the background color to transparent
        elevation: 0,
        // Remove the shadow
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/page-1/images/frame-12-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
       child:Container(
        width: double.infinity,
        height: 700,
        padding: EdgeInsets.all(15),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.asset(
            'assets/page-1/images/profile.png',
            height: 120,
            width: 120,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Text(
              userName ?? '',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3333333333 * ffem / fem,
                letterSpacing: 0.400000006 * fem,
                color: Colors.blueAccent,
              ),
            ),
          ),Container(
            child: Text(
              userEmail ?? '',
              textAlign: TextAlign.center,
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3333333333 * ffem / fem,
                letterSpacing: 0.400000006 * fem,
                color: Colors.blueAccent,
              ),
            ),
          ),

          const SizedBox(
            height: 15,
          ),
          Text(
            "MY POEMS",
            textAlign: TextAlign.center,
            style: SafeGoogleFont(
              'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.3333333333 * ffem / fem,
              letterSpacing: 0.400000006 * fem,
              color: const Color(0xff1b1b1f),
            ),
          ),
           Container(
           height: 300, // Set the height as needed
           child: myPoems.isEmpty
               ? Center(child: Text('No poems available'))
               : ListView.builder(
             itemCount: myPoems.length,
             itemBuilder: (context, index) {
               final poem = myPoems[index];
               return ListTile(
                 title: Text(poem['poem_name']),
                 // Add more details or customize the ListTile as needed
               );
             },
           )),

        ]),
      )),

    );
  }
}
