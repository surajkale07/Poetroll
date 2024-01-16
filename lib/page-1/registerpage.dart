import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;


final FirebaseAuth _auth  = FirebaseAuth.instance;

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {

  final TextEditingController _email =TextEditingController();
  final TextEditingController _password =TextEditingController();
  final TextEditingController _fullname =TextEditingController();
  final TextEditingController _mob =TextEditingController();
  late bool _sucess;
  late String _userEmail;

  void  _register() async {
    try {
      if (formKey.currentState!.validate()) {
        final User? user = (
            await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text)
        ).user;
        if (user != null) {
          setState(() {
            _sucess = true;
            _userEmail = user.email!;
            Map<String, dynamic> data = {
              "full_name": _fullname.text,
              "email": _email.text
            };
            FirebaseFirestore.instance.collection("users").add(data);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Register Successful"),
            ));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyLogin()),
            );
          });
        }
      }
    }catch(error){
      setState(() {
        _sucess =false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Registration failed: $error"),
        ));
      });
    }
  }

  Future<void> Register(
      String name, String email, String mob, String password) async {
    final client = http.Client();

    try {
      if (formKey.currentState!.validate()) {

        final url = Uri.parse('https://www.poetroll.com/webservices/signup.php');
      final response = await client.post(
        url.replace(queryParameters: {
          'name': name,
          'email': email,
          'mob': mob,
          'password': password,
        }),
        // You can customize headers if needed
        // headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 301 || response.statusCode == 302) {
        // Handle redirection if needed
        final newLocation = response.headers['location'];
        if (newLocation != null) {
          print('Redirected to: $newLocation');
          // Manually follow the redirection
          final redirectedResponse = await client.get(Uri.parse(newLocation));
          // Process the redirected response as needed
          print('Redirected response: ${redirectedResponse.body}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Register Successfully"),
          ));
        } else {
          print('Redirection location header not found');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong try again"),
          ));
        }
      } else if (response.statusCode == 200) {
        // Comment posted successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Register Successfully"),
        ));
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something went wrong try again"),
        ));
        print('Failed to post comment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }}
    } finally {
      client.close(); // Close the client to release resources
    }
  }

  final formKey =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 100),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullname,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter Full name";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _email,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value!)){
                                  return "Enter correct email Address";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: _mob,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Mobile No.",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Enter valid Mobile No.";
                                }else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              onTap: (){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Enter the password of your choice"),
                                ));
                              },
                              controller: _password,
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Password must be filled";
                                }else {
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
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async{
                                        Register(_fullname.text,_email.text,_mob.text,_password.text);
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
                                    Navigator.of(context).pushReplacementNamed("/login");
                                  },
                                  child: Text(
                                    'Sign In',
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
      ),
    );
  }
}