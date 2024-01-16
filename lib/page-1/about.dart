import 'dart:ffi';

import 'package:flutter/material.dart';


import '../utils.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("About Us"),
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/page-1/images/poetroll_logo.png',
                height: 100,
                width: 100,
              ),
              SizedBox(height: 20,),
              Text(
                'Version: 3.0',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  height: 1.1725,
                  letterSpacing: 0.0120000002,
                  color: const Color(0xff1b1b1f),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                height: 250,
                width: 250,
                child: Text(
                  "POETROLL is an app created by Aries Epica under the guidance of Mr. Sohan Roy -  Director, Creative Head and Project Designer"
                      " of award-winning films and documentaries. Sohan Roy is the CEO and founder of Aries Group of Companies."
                      " In Poetroll, Poets can register and can add many poems in audio, video, image, and text formats. These poems will be visible"
                      " to the poem lovers and can mark as favorites. Poetroll also has an option to share the poems to social media portals."
                      " Poem lovers can sponsor any poem by adding the sponsorship band to each poem",
                  style: SafeGoogleFont(
                    'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    height: 1.1725,
                    letterSpacing: 0.0120000002,
                    color: const Color(0xff1b1b1f),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'For Any Queries: Mr.Hari - +919539000826',
                style: SafeGoogleFont(
                  'Roboto',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  height: 1.1725,
                  letterSpacing: 0.0120000002,
                  color: const Color(0xff1b1b1f),
                ),
              ),
                  Image.asset(
                  'assets/page-1/images/Aries-Group.jpg',
                  height: 200,
                  width: 200,
                ),


              ],
          ),
        ));
  }
}
