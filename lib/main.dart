import 'package:flutter/material.dart';
import 'package:socialMedia_stories/story/story.dart';

void main()=> runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Media Story',
      debugShowCheckedModeBanner: false,
      home: StoryScreen(),
    );
  }
}