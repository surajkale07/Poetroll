import 'package:flutter/material.dart';
import 'package:myapp/page-1/bookcard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../utils.dart';


class Upload extends StatefulWidget {
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  TextEditingController _title = TextEditingController();
  TextEditingController _titleEng = TextEditingController();
  TextEditingController _attachmentController = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _lyrics = TextEditingController();
  TextEditingController _singer = TextEditingController();
  TextEditingController _music = TextEditingController();
  TextEditingController _sourceFile = TextEditingController();


  final formKey = GlobalKey<FormState>();


  Future<void> uploadPoem() async {
    if (formKey.currentState!.validate()) {
      // Get form data
      String title = _title.text; // Replace with your form data
      String titleEng = _titleEng.text; // Replace with your form data
      String description = _description.text; // Replace with your form data
      String category = '1'; // Replace with your form data
      String type = 'image'; // Replace with your form data
      String lyrics = _lyrics.text; // Replace with your form data
      String singer = _singer.text; // Replace with your form data
      String music = _music.text; // Replace with your form data
      String sourceFile = _attachmentController.text; // File path

      String apiUrl =
          'https://www.poetroll.com/webservices/add_poem.php?user_token=797658&title=$title&title_eng=$titleEng&description=$description&category=$category&type=$type&lyrics=$lyrics&singer=$singer&music=$music&source_file=$sourceFile&viewed=1&view_count=0&sort_order=396&approved=0';
      // Make the HTTP request
      try {
        final response = await http.post(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          // Parse the response
          print(response.body);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Uploaded Successfully"),
          ));
          // Handle success
        } else {
          // Handle errors
          print('Error: ${response.reasonPhrase}');
        }
      } catch (e) {
        // Handle exceptions
        print('Exception: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text("Upload Poem"),
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
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
      child: Container(
        height: 800,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _title,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Title"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Title";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _titleEng,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Title in English"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Title";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _description,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Description"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Description";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _lyrics,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Lyrics"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Lyrics";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _singer,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Singer"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Singer";
                            } else {
                              return null;
                            }
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _music,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Music Director"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Music Director";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _attachmentController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text("Attachment"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Attachment";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              PlatformFile file = result.files.first;

                              // Set the selected file path to the controller
                              _attachmentController.text = file.path ?? '';
                            }
                          },
                          child: Text("Pick Attachment"),
                        ),


                        InkWell(
                          onTap: (){
                            uploadPoem();

                          },

                          child: Container(
                            height: 50,
                            width: 200,

                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                            child: Text(
                              "SUBMIT",
                              textAlign: TextAlign.center,
                              style: SafeGoogleFont(
                                'Roboto',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3333333333,
                                letterSpacing: 0.400000006 ,
                                color: Colors.white,
                              ),
                            ),
                          ))
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      )
    );
  }

}
