import 'dart:convert';

import 'package:ecommapp/HomePage.dart';
import 'package:ecommapp/SignupPage.dart';
import 'package:ecommapp/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    builder: EasyLoading.init(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool passwordvisible1 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordvisible1 = true;
  }

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double theight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        var result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: Color(0xff3A557C),
              title: Text("Are you sure want to exit??",
                  style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    )),
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No", style: TextStyle(color: Colors.white)))
              ]),
        );
        return result ?? false;
      },
      child: Scaffold(
        body: Container(
            height: theight,
            width: twidth,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/blue-wall-background.jpg"),
                    fit: BoxFit.cover)),
            // color: Color(0xff759AB4),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                        width: 100,
                        height: 100,
                        child: Image(
                          color: Color(0xff3A557C),
                          image: AssetImage(
                              "images/pngfind.com-retail-icon-png-3838815.png"),
                          fit: BoxFit.fill,
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        height: theight * 0.50,
                        width: twidth * 0.9,
                        decoration: BoxDecoration(color: Colors.white
                            // color: Color(0xffE6E6E6),
                            ),
                        child: Column(
                          children: [
                            Container(
                                width: twidth * 0.9,
                                height: theight * 0.10,
                                decoration: BoxDecoration(
                                  color: Color(0xff3A557C),
                                ),
                                child: Center(
                                    child: Text(
                                  "customer login".toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4,
                                      color: Color(0xffEFF2F1)),
                                ))),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                              child: TextField(
                                controller: username,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    prefixIcon: FaIcon(FontAwesomeIcons.user,
                                        size: 30, color: Color(0xff759AB4)),
                                    border: InputBorder.none,
                                    hintText: "Username",
                                    hintStyle: TextStyle(
                                        letterSpacing: 2,
                                        color: Color(0xff759AB4))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                controller: password,
                                obscureText: passwordvisible1,
                                decoration: InputDecoration(
                                    prefixIcon: FaIcon(FontAwesomeIcons.lock,
                                        size: 30, color: Color(0xff759AB4)),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            print(passwordvisible1);
                                            passwordvisible1 =
                                                !passwordvisible1;
                                          });
                                        },
                                        icon: Icon(
                                            passwordvisible1
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color(0xff3A557C),
                                            size: 25)),
                                    hintStyle: TextStyle(
                                        letterSpacing: 2,
                                        color: Color(0xff759AB4))),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  SplashScreen.myScreen = true;

                                  SplashScreen.prefs!.setBool(
                                      "setbool", SplashScreen.myScreen);
                                });

                                EasyLoading.show(status: "Loading...");

                                Map mydata1 = {
                                  'name': username.text,
                                  'password': password.text
                                };

                                var url = Uri.parse(
                                    'https://vyasenterprize.000webhostapp.com/MyEcomm/mylogin.php');
                                var response =
                                    await http.post(url, body: mydata1);
                                print(
                                    'Response status: ${response.statusCode}');
                                print('Response body: ${response.body}');

                                var mymap1 = jsonDecode(response.body);

                                loginclass ll = loginclass.fromJson(mymap1);

                                var mymap2 = jsonEncode(ll);

                                setState(() {
                                  SplashScreen.myalldata = mymap2;

                                  SplashScreen.prefs!.setString(
                                      "getdata", "${SplashScreen.myalldata}");

                                  SplashScreen.userid = "${ll.userdata!.iD}";

                                  SplashScreen.prefs!
                                      .setString("userid", SplashScreen.userid);
                                });

                                if (ll.connection == 1) {
                                  if (ll.result == 1) {
                                    EasyLoading.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Login Succesfully")));

                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return HomePage(ll.userdata);
                                      },
                                    ));
                                  } else {
                                    EasyLoading.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Try Again !! Somrthing Went Wrong")));
                                  }
                                }
                              },
                              child: Container(
                                height: theight * 0.06,
                                width: twidth,
                                decoration:
                                    BoxDecoration(color: Color(0xff3A557C)),
                                child: Center(
                                  child: Text(
                                    "Login".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 4,
                                        color: Color(0xffEFF2F1)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an Acoount ??",
                                      style:
                                          TextStyle(color: Color(0xff759AB4))),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return SignupPage();
                                          },
                                        ));
                                      },
                                      child: Text(
                                        "Click Here",
                                        style: TextStyle(
                                          color: Color(0xff3A557C),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.fingerprint,
                          size: 50, color: Color(0xff3A557C)),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class loginclass {
  int? connection;
  int? result;
  Userdata? userdata;

  loginclass({this.connection, this.result, this.userdata});

  loginclass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    return data;
  }
}

class Userdata {
  String? iD;
  String? nAME;
  String? eMAIL;
  String? nUMBER;
  String? dOB;
  String? qUALIFICATION;
  String? gENDER;
  String? pASSWORD;
  String? iMAGEPATH;

  Userdata(
      {this.iD,
      this.nAME,
      this.eMAIL,
      this.nUMBER,
      this.dOB,
      this.qUALIFICATION,
      this.gENDER,
      this.pASSWORD,
      this.iMAGEPATH});

  Userdata.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    nAME = json['NAME'];
    eMAIL = json['EMAIL'];
    nUMBER = json['NUMBER'];
    dOB = json['DOB'];
    qUALIFICATION = json['QUALIFICATION'];
    gENDER = json['GENDER'];
    pASSWORD = json['PASSWORD'];
    iMAGEPATH = json['IMAGEPATH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['NAME'] = this.nAME;
    data['EMAIL'] = this.eMAIL;
    data['NUMBER'] = this.nUMBER;
    data['DOB'] = this.dOB;
    data['QUALIFICATION'] = this.qUALIFICATION;
    data['GENDER'] = this.gENDER;
    data['PASSWORD'] = this.pASSWORD;
    data['IMAGEPATH'] = this.iMAGEPATH;
    return data;
  }
}
