import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/page-1/Login.dart';
import 'package:myapp/page-1/about.dart';
import 'package:myapp/page-1/book.dart';
import 'package:myapp/page-1/favourite.dart';
import 'package:myapp/page-1/mostviewed.dart';
import 'package:myapp/page-1/natylosavam.dart';
import 'package:myapp/page-1/poembyreader.dart';
import 'package:myapp/page-1/poems.dart';
import 'package:myapp/page-1/profile.dart';
import 'package:myapp/page-1/recentPoem.dart';
import 'package:myapp/page-1/shortpoem.dart';
import 'package:myapp/page-1/stories.dart';
import 'package:myapp/page-1/talenthunt.dart';
import 'package:myapp/page-1/upload.dart';
import 'package:myapp/page-1/wishes.dart';
import 'package:myapp/utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_card.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';




class Home extends StatefulWidget {
  const Home({this.videoUrl}); // Remove the 'required' keyword if not needed

  final String? videoUrl; // Update the type to be nullable if not required

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> poemData = [];
  List<Map<String, dynamic>> poemData2 = [];
  bool isLoading = true;
  String? userEmail;

  List<Map<String, String>> advertisementData = [
    {"id": "2", "type": "image", "url": "http://alfilmservices.com/","image_path": "http://poetroll.com/images/advertisements/AL Film Services-1.jpg"},
    {"id":"3","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/Approvals-1.jpg"},
    {"id":"4","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/Aries Group Logos-1.jpg"},
    {"id":"5","type":"image","url":"https://www.ariesmar.com/","image_path":"http://poetroll.com/images/advertisements/Aries ONE-1.jpg"},
    {"id":"6","type":"image","url":"http://www.arieshomeplex.com/","image_path":"http://poetroll.com/images/advertisements/Aries Plex-1.jpg"},
    {"id":"7","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/Aries Staffing Solutions-1.jpg"},
    {"id":"8","type":"image","url":"http://ariesvismayasmax.com/","image_path":"http://poetroll.com/images/advertisements/Aries Vismayas Max-1.jpg"},
    {"id":"9","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/ATPL-1.jpg"},
    {"id":"10","type":"image","url":"http://ariesaviationservices.com/","image_path":"http://poetroll.com/images/advertisements/Aviation NDT AUS-1.jpg"},
    {"id":"11","type":"image","url":"https://biztvevents.com/","image_path":"http://poetroll.com/images/advertisements/Biz Tv_01-1.jpg"},
    {"id":"12","type":"image","url":"https://biztvevents.com/","image_path":"http://poetroll.com/images/advertisements/Biz Tv_01-2.jpg"},
    {"id":"13","type":"image","url":"https://www.biztvnetworks.com/","image_path":"http://poetroll.com/images/advertisements/Biz Tv_Network-1.jpg"},
    {"id":"14","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/Botel-1.jpg"},
    {"id":"15","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/Chundan-1.jpg"},
    {"id":"16","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/DAM999-1.jpg"},
    {"id":"17","type":"image","url":"https://www.effism.com/","image_path":"http://poetroll.com/images/advertisements/Effism-1.jpg"},
    {"id":"18","type":"image","url":"https://www.ariesepica.com/","image_path":"http://poetroll.com/images/advertisements/Epica_page-1.jpg"},
    {"id":"19","type":"image","url":"https://www.ariesgroupglobal.com/","image_path":"http://poetroll.com/images/advertisements/Group Company list-1.jpg"},
    {"id":"20","type":"image","url":"http://arieshomeplex.com/","image_path":"http://poetroll.com/images/advertisements/Home Plex-1.jpg"},
    {"id":"21","type":"image","url":"http://indywoodbillionairesclub.com/","image_path":"http://poetroll.com/images/advertisements/IBC-1.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchData2();
    getuser();
  }
  String? usertoken;
  Future<void> getuser()  async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail= prefs.getString("name");
      usertoken= prefs.getString("usertoken");
    });
  }
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://www.poetroll.com/webservices/list-recent-most-view.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data']['Most_viewed_poems'] is List) {
        setState(() {
          List<Map<String, dynamic>> allPoems = List<Map<String, dynamic>>.from(data['data']['Most_viewed_poems']);
          // Fetch only the last 4 items
          poemData = allPoems.sublist(
            allPoems.length >= 4 ? allPoems.length - 4 : 0,
            allPoems.length,
          ).reversed.toList();
        });
      } else {
        print('Data is not in the expected format');
      }
    } else {
    }
  }


  Future<void> fetchData2() async {
    final response = await http.get(Uri.parse(
        'https://www.poetroll.com/webservices/list-recent-most-view.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data']['recent_poems'] is List) {
        setState(() {
          poemData2 =
              List<Map<String, dynamic>>.from(data['data']['recent_poems']);
        });
      } else {
        print('Data is not in the expected format');
      }
    } else {
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit.'),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false, // Remove the back arrow
            backgroundColor: Colors.transparent,
            // Set the app bar background color to transparent
            elevation: 0,
            // Remove the app bar shadow
            flexibleSpace: Container(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 3),
              width: 360,
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/page-1/images/frame-12-bg.png'),
                ),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x3f000000),
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 57, 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            width: 52,
                            height: 50,
                            child: Image.asset(
                              'assets/page-1/images/poetroll_logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                            child: const Text(
                              'Poetroll',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.1725,
                                letterSpacing: 0.014,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 370,
                padding: EdgeInsets.all(15),
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1),
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Shortpoem()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.article,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "അനുകാവ്യം (Short poems)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Stories()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.auto_stories,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "കഥകൾ (Stories)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Book()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "പുസ്തകങ്ങൾ (Books)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Poems()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.description_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "കവിതകൾ (Poems)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Natylosavam()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.attractions,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "നാട്യോത്സവം (Natyolsavam)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Talenthunt()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_search,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "ടാലന്റ് ഹണ്ട് (Talent hunt)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Wishes()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "ആശംസകൾ (Wishes)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Favourite()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 30,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "പ്രിയപ്പെട്ടവ (Favourite)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const poemByReader()));
                    },
                    child: Container(
                      width: 150, // Adjust the width as needed
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.handshake,
                            size: 25,
                            color: Colors.white,
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              child: const IntrinsicHeight(
                                child: Text(
                                  "വായനക്കാരുടെ കവിതകൾ (Poems by Readers)",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              )),


                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(
                    'Recent Poems',
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1725 * ffem / fem,
                      letterSpacing: 0.0120000002 * fem,
                      color: const Color(0xff1b1b1f),
                    ),
                  ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => const RecentPoem()));
                      },
                    child: Text(
                    'View All >',
                    style: SafeGoogleFont(
                      'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.1725 * ffem / fem,
                      letterSpacing: 0.0120000002 * fem,
                      color: Colors.blueAccent,
                    ),
                  )),
                  ],) 
                 
                ),
                Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 10,crossAxisSpacing: 10),
                        child: Container(
                          child: Row(
                            children: poemData2.map((poem) {
                              return InkWell(
                                onTap: () {
                                  // Handle card tap
                                },
                                child: CustomCard(
                                  backgroundImage:poem['image_path'],
                                  title: poem['poem_name'], poem_id: poem['poem_id'], authorname: poem['author_name'],
                                ),
                              );
                            }).toList(),
                          ),
                        ))),

                SizedBox(height: 20,),


                CarouselSlider(
                  options: CarouselOptions(
                    height: 350,
                    aspectRatio: 16/9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                items: advertisementData.map((data){
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          _launchURL(data['url'] ?? '');
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            image: DecorationImage(
                              image: NetworkImage(data['image_path'] ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20,),

              Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Most Viewed',
                        style: SafeGoogleFont(
                          'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.1725 * ffem / fem,
                          letterSpacing: 0.0120000002 * fem,
                          color: const Color(0xff1b1b1f),
                        ),
                      ),
                   InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => const MostViewed()));
                    },
                      child: Text(
                        'View All >',
                        style: SafeGoogleFont(
                          'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.1725 * ffem / fem,
                          letterSpacing: 0.0120000002 * fem,
                          color: Colors.blueAccent,
                        ),
                      )),
                    ],)
              ),

                 Container(
                   height: 350,
                  padding: EdgeInsets.all(10),
                  child: GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1),
                      children: poemData.map((poem) {
                        return InkWell(
                          onTap: () {
                            // Handle card tap
                          },
                          child: CustomCard(
                            backgroundImage: poem['image_path'],
                            title: poem['poem_name'],
                            poem_id: poem['poem_id'], authorname: poem['author_name']
                          ),
                        );
                      }).toList(),
                    ),
                ),
            ],
          )),

          floatingActionButton: SpeedDial(
              icon: Icons.menu,
              backgroundColor: Colors.redAccent,
              children: [

                if (usertoken != null && usertoken!.isNotEmpty)
                  SpeedDialChild(
                    child: const Icon(Icons.logout, color: Colors.white),
                    label: 'Logout',
                    backgroundColor: Colors.blueAccent,
                    onTap: () async {
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                    },
                  ),
                if (usertoken == null || usertoken!.isEmpty)
                  SpeedDialChild(
                    child: const Icon(Icons.login, color: Colors.white),
                    label: 'Login',
                    backgroundColor: Colors.blueAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyLogin()),
                      );
                    },
                  ),
                SpeedDialChild(
                  child: const Icon(Icons.person,color: Colors.white),
                  label: 'Profile',
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile()));                     },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.info,color: Colors.white),
                  label: 'About App',
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => About()));                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.cloud_upload,color: Colors.white),
                  label: 'Upload',
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    if (usertoken != null && usertoken!.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Upload()
                          ));
                    }else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyLogin()));
                    }
                  },
                ),

              ]),

          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,

          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.home,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/home");
                      },
                    ),
                    const Text(
                      'Home',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.description_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/poem");
                      },
                    ),
                    const Text(
                      'Poems',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.article,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed("/shortpoem");
                      },
                    ),
                    const Text(
                      'Micro',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu_book,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/book");
                      },
                    ),
                    const Text(
                      'Book',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

