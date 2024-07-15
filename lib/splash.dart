import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialapp/newsfeed.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Newsfeed(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: const Text(
              "Hello !!",
              style: TextStyle(fontSize: 40),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .then(delay: 200.ms) // baseline=800ms
                .slide(),
          )
        ],
      ),
    );
  }
}
//Text("Hello").animate() 
//   .fadeIn(duration: 600.ms)
//   .then(delay: 200.ms) // baseline=800ms
//   .slide()