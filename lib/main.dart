import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cantique_ebb_flutter/search.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cantique_ebb_flutter/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black),
              color: Color(0xFF5A1515))),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/splash.jpg"),
          fit: BoxFit.cover,
        )),
      ),
      nextScreen: /*Home()*/ Home(),
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(seconds: 3),
      splashIconSize: double.infinity,
    );
  }
}

class HtmlText extends StatelessWidget {
  const HtmlText({Key? key}) : super(key: key);
  final String htmlcontent = """
    <h1>Hello </h1>
    <h2 style='color:red'>World</h2>
    <p>This is sample paragraph</p>
    <p> H<sup>2</sup>O </p>
    <p> A<sub>2</sub> </p>
    <i>italic</i> <b>bold</b> <u>underline</u> <s>strike </s>
    <ul>
      <li>Item 1</li>
      <li>Item 2</li>
      <li>Item 3</li>
    </ul>
    <br><br>
    <img src="https://vrsofttech.com/flutter-tutorials/images/vr.png" width="100">
  """;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: Html(
                data: htmlcontent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
