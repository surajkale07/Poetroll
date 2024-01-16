import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// ignore: camel_case_types
class poemByReader extends StatefulWidget {
  const poemByReader({super.key});

  @override
  State<poemByReader> createState() => _poemByReaderState();
}

// ignore: camel_case_types
class _poemByReaderState extends State<poemByReader> {
  List<Map<String, dynamic>> poemData = [];
  List<Map<String, dynamic>> filteredPoemData = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://www.poetroll.com/webservices/list-book-poem.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        poemData = List<Map<String, dynamic>>.from(data['data']);
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
        title: const Text("Poem By Reader"),
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SizedBox(
        //       width: 150,
        //       child: TextFormField(
        //         controller: searchController,
        //         style: TextStyle(
        //           color: Colors.white,
        //         ),
        //         decoration: InputDecoration(
        //           hintText: "Search ",
        //           filled: false,
        //           hintStyle: TextStyle(
        //             color: Colors.white,
        //           ),
        //           labelStyle: TextStyle(
        //             color: Colors.white,
        //           ),
        //         ),
        //         onChanged: (query) => searchPoems(query),
        //       ),
        //     ),
        //   ),
        // ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/page-1/images/frame-12-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Coming Soon...!'),
      ),
    );
  }

}
