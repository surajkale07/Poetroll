import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page-1/registerpage.dart';
import 'package:myapp/page-1/shortpoem.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_otp/email_otp.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _emailforget = TextEditingController();
  final TextEditingController _mob = TextEditingController();

  late bool _sucess;
  late String _userEmail;

  void _forget() {
    if (formKey.currentState!.validate()) {
      final check = _auth.sendPasswordResetEmail(email: _email.text);
      if (check != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Check your Email inbox"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Enter Email address"),
      ));
    }
  }


  Future<void> login(String email, String password, String mob) async {
    final client = http.Client();

    try {
      if (formKey.currentState!.validate()) {
        final url = Uri.parse(
            'https://www.poetroll.com/webservices/signin.php');
        final response = await client.post(
          url,
          body: {
            'email': email,
            'mob': mob,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['data'] != null && data['data']['status'] == "true") {
            final usertoken = data['data']['usertoken'];
            final username = data['data']['name'];


            // Save usertoken to local storage (shared preferences)
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('usertoken', usertoken);
            prefs.setString('email', _email.text );
            prefs.setString('name', username );


            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Login Successful"),
            ));
            Navigator.of(context).pushReplacementNamed("/home");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Incorrect email or password"),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong. Please try again."),
          ));
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }
  }




  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: Stack(
          children: [

            SingleChildScrollView(
              child: Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 35, top: 130),
                        child: Text(
                          'Welcome\nBack',
                          style:SafeGoogleFont(
                            'Roboto',
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            height: 1.3333333333 ,
                            letterSpacing: 0.400000006,
                            color: Colors.white,
                        )),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _email,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade300,
                                  filled: true,
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                        .hasMatch(value!)) {
                                  return "Enter correct email Address";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _mob,
                              style: TextStyle(),
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade300,
                                  filled: true,
                                  hintText: "Mobile No. ",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "MobileNo. must be filled";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _password,
                              style: TextStyle(),
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade300,
                                  filled: true,
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password must be filled";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                 CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        login(_email.text, _password.text, _mob.text);

                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyRegister()));
                                  },
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xff4c505b),
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
