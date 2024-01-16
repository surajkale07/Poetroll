import 'package:flutter/material.dart';
import 'package:myapp/page-1/small_card.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/page-1/smallcardshimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';


class MostViewed extends StatefulWidget {
  const MostViewed({super.key});

  @override
  State<MostViewed> createState() => _MostViewedState();
}

class _MostViewedState extends State<MostViewed> {
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
    final response = await http.get(Uri.parse(
        'https://www.poetroll.com/webservices/list-recent-most-view.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data']['Most_viewed_poems'] is List) {
        setState(() {
          // Reverse the list before assigning it to poemData
          poemData = List<Map<String, dynamic>>.from(data['data']['Most_viewed_poems']).reversed.toList();
          filteredPoemData = List.from(poemData); // Initialize filtered data with all data
          isLoading = false;
        });
      } else {
        print('Data is not in the expected format');
        isLoading = false;
      }
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
        title: const Text("Most Viewed"),
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
                  hintText: "Search Poems",
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
                poem_id: poem['poem_id'],
                authorname: poem['author_name'],
              ),
            );
          },
        ),
      ),
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
                  'HOME',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.description_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/shortpoem");
                  },
                ),
                const Text(
                  'MICRO',
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
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/poem");
                  },
                ),
                const Text(
                  'POEM',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.people,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/profile");
                  },
                ),
                const Text(
                  'PROFILE',
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
