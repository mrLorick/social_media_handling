import 'package:flutter/material.dart';
import 'package:social_media_handling/src/social_media_handling.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Social Media Handling')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              SocialMediaHandling.openInstagram('flutter.dev');
            },
            child: const Text('Open Instagram'),
          ),
        ),
      ),
    );
  }
}
