

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page-1/Login.dart';
import 'package:myapp/page-1/about.dart';
import 'package:myapp/page-1/book.dart';
import 'package:myapp/page-1/home.dart';
import 'package:myapp/page-1/poems.dart';
import 'package:myapp/page-1/profile.dart';
import 'package:myapp/page-1/registerpage.dart';
import 'package:myapp/page-1/shortpoem.dart';
import 'package:myapp/page-1/splashscreen.dart';
void main()async{
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	await DeviceInfoPlugin().androidInfo;

	// await Firebase.initializeApp();
	runApp(
			 MaterialApp(
		debugShowCheckedModeBanner: false,
		routes: {
			"/":(context) => const Splash(),
			"/login":(context) => const MyLogin(),
			"/register":(context) => const MyRegister(),
			"/home": (context) => const Home(),
			"/explore":(context) => Poems(),
			"/profile":(context) => const Profile(),
			"/shortpoem":(context) => Shortpoem(),
			"/poem":(context) => Poems(),
			"/book":(context) => Book(),
			"/about":(context) => About(),



		},
	));
}

