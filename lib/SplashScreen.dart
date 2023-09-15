import 'package:ecommapp/HomePage.dart';
import 'package:ecommapp/SignupPage.dart';
import 'package:ecommapp/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static SharedPreferences? prefs;

  static bool myScreen = false;

  static String myalldata = "";

  static String userid = "";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharePreferanceClass();
  }

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double theight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("myEcomApp",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2)),
            Container(
                width: twidth * 0.5,
                height: twidth * 0.5,
                child: Lottie.asset(
                    fit: BoxFit.fill, "lottie/animation_lkb63b1j.json")),
          ],
        ),
      ),
    );
  }

  Future<void> SharePreferanceClass() async {
    await Future.delayed(Duration(seconds: 5));

    SplashScreen.prefs = await SharedPreferences.getInstance();

    SplashScreen.myScreen = SplashScreen.prefs!.getBool("setbool") ?? false;

    SplashScreen.myalldata = SplashScreen.prefs!.getString("getdata") ?? "";

    SplashScreen.userid = SplashScreen.prefs!.getString("userid") ?? "";

    print("${SplashScreen.myScreen}");

    if (SplashScreen.myScreen) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
      ));
    }
  }
}
