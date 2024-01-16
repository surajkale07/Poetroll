import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:myapp/page-1/profile.dart';
import 'package:myapp/page-1/small_card.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/page-1/smallcardshimmer.dart';
import 'package:myapp/page-1/upload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';

import 'Login.dart';
import 'about.dart';


class Natylosavam extends StatefulWidget {
  @override
  State<Natylosavam> createState() => _NatylosavamState();
}

class _NatylosavamState extends State<Natylosavam> {
  List<Map<String, dynamic>> poemData = [];
  List<Map<String, dynamic>> filteredPoemData = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getuser();
    fetchData();
  }
  String? usertoken;
  Future<void> getuser()  async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usertoken= prefs.getString("usertoken");
    });
  }
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://www.poetroll.com/webservices/list-dance.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        poemData = List<Map<String, dynamic>>.from(data['data']).reversed.toList();
        filteredPoemData = List.from(poemData); // Initialize filtered data with all data
        isLoading = false;
      });
    } else {
      isLoading = false;
    }
  }

  void searchPoems(String query) {
    setState(() {
      filteredPoemData = poemData
          .where((poem) =>
          poem['poem_name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text("Natyolsavam"),
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 150,
              child: TextFormField(
                controller: searchController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  hintText: "Search Natyolsavam",
                  filled: false,
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onChanged: (query) => searchPoems(query),
              ),
            ),
          ),
        ],
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
          padding: const EdgeInsets.all(10),
          child: filteredPoemData.isEmpty
              ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.48,
              ),
              itemCount: 9, // Adjust the number of shimmer items as needed
              itemBuilder: (context, index) => SmallCardShimmer(),
            ),
          )
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.48,
            ),
            itemCount: filteredPoemData.length,
            itemBuilder: (context, index) {
              final poem = filteredPoemData[index];
              return InkWell(
                onTap: () {
                  // Handle onTap if needed
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(poemId: poem['poem_id'])));
                },
                child: SmallCard(
                  backgroundImage: poem['image_path'],
                  title: poem['poem_name'],
                  poem_id: poem['poem_id'], authorname: '',
                ),
              );
            },
          ),
      ),
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
                    color: Colors.black,
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
                    color: Colors.red,
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
    );
  }
}
