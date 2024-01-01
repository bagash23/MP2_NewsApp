import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:news_app/screen/news_home.dart';

class NewsSplash extends StatefulWidget {
  const NewsSplash({super.key});

  @override
  State<NewsSplash> createState() => _NewsSplashState();
}

class _NewsSplashState extends State<NewsSplash> {
  void _startSplash() {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewsHome()));
    });
  }

  @override
  void initState() {
    _startSplash();
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Container(
        child: Center(
          child: AnimatedTextKit(animatedTexts: [
            TypewriterAnimatedText(
              "News App",
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 500),
            )
          ]),
        ),
      ),
    );
  }
}