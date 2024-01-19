import 'dart:async';

import 'package:advanc_task_10/main.dart';
import 'package:advanc_task_10/pages/master_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  StreamSubscription<User?>? _listener;
  @override
  void initState() {
    checkUser();
    super.initState();
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 2));
    _listener = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MyHomePage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MasterPage()));
      }
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 245, 73, 131),
          Color.fromARGB(137, 189, 24, 24),
          Color.fromARGB(136, 189, 24, 159),
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      )),
      child:
          const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.shopping_cart,
          size: 200,
          color: Colors.white,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Shop",
          style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromARGB(255, 241, 238, 238),
              fontSize: 50),
        ),
        SizedBox(
          height: 50,
        ),
        SpinKitFadingCube(
          color: Color.fromARGB(255, 173, 228, 10),
          size: 50.0,
        ),
      ]),
    ));
  }
}
