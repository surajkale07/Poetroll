import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page-1/home.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/page-1/images/splashscreen.jpeg",
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,

      ),

        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.asset(
        //         'assets/page-1/images/poetroll_logo.png',
        //         fit: BoxFit.contain,
        //       ),
        //       SizedBox(height: 16), // Add some spacing between the image and text
        //       Text(
        //         'POETROLL',
        //         style: TextStyle(
        //           fontSize: 40,
        //           fontWeight: FontWeight.bold,
        //           color: Colors.blueAccent,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
    );
  }


  startTimer() {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() {
    // if (user != null){
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => Home()
    //   ));
    // }else{
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => MyLogin()
    //   ));
    // }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  }
}
