import 'dart:convert';
import 'dart:io';

import 'package:ecommapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static RgisterData? dd;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // late DateTime dob;
  String gender = "male";

  bool cricketcheck = true;
  bool Readingcheck = true;
  bool Travellingcheck = true;

  String Imagepick = "";

  TextEditingController dateController = TextEditingController();
  late String formattedDate;

  List items = [
    "Under Graduate",
    "Graduate",
    "Post Graduate",
  ];

  var curruntvalue = "Graduate";

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool namecheck = false;
  String? name_error;

  bool numbercheck = false;
  String? number_error;

  bool emailcheck = false;
  String? email_error;

  bool passcheck = false;
  String? pass_error;

  bool errorDObcheck = false;
  String? dob_error;

  bool passwordvisible1 = false;

  @override
  void initState() {
    dateController.text = "";

    passwordvisible1 = true;

    print(dateController.text);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double theight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          height: theight,
          width: twidth,
          // color: Color(0xff759AB4),
          // decoration: BoxDecoration(image: DecorationImage(
          //     image: AssetImage("images/blue-wall-background.jpg"),
          //     fit: BoxFit.cover)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    elevation: 40,
                    child: Container(
                      height: theight * 0.78,
                      width: twidth * 0.9,
                      decoration: BoxDecoration(color: Colors.white
                          // color: Color(0xffE6E6E6),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                                width: twidth * 0.9,
                                height: theight * 0.06,
                                decoration:
                                    BoxDecoration(color: Color(0xff3A557C)),
                                child: Center(
                                    child: Text(
                                  "customer SignUp".toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 4,
                                      color: Color(0xffEFF2F1)),
                                ))),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  ImagePicker picker = ImagePicker();

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          ElevatedButton.icon(
                                              onPressed: () async {
                                                final XFile? image =
                                                    await picker.pickImage(
                                                        source:
                                                            ImageSource.camera);

                                                setState(() {
                                                  Imagepick = image!.path;
                                                });
                                              },
                                              icon: Icon(Icons.camera),
                                              label: Text("Camera")),
                                          ElevatedButton.icon(
                                              onPressed: () async {
                                                final XFile? image =
                                                    await picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);

                                                setState(() {
                                                  Imagepick = image!.path;
                                                });
                                              },
                                              icon: Icon(Icons.browse_gallery),
                                              label: Text("Gallery")),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Imagepick == ""
                                    ? CircleAvatar(
                                        child: FaIcon(FontAwesomeIcons.plus),
                                        backgroundColor: Color((0xffEFF2F1)),
                                        radius: 50,
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(File(Imagepick)))),
                            Imagepick == ""
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Add Your Image".toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Color(0xff759AB4),
                                          letterSpacing: 1),
                                    ),
                                  ))
                                : Container(),
                            Container(
                              height: theight * 0.50,
                              width: twidth * 0.90,
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  TextField(
                                    controller: name,
                                    onChanged: (value) {
                                      final regex = RegExp(r'^[a-zA-Z ]+$');

                                      setState(() {
                                        if (name.text.isEmpty) {
                                          namecheck = true;
                                          name_error = "Enter the Name";
                                        } else if (!regex.hasMatch(name.text)) {
                                          namecheck = true;
                                          name_error = "Invalid Name";
                                        } else {
                                          namecheck = false;
                                          name_error = null;
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                        errorText:
                                            namecheck ? name_error : null,
                                        prefixIconConstraints: BoxConstraints(
                                            maxHeight: 20, minWidth: 30),
                                        prefixIcon: FaIcon(
                                            FontAwesomeIcons.solidUserCircle,
                                            size: 15,
                                            color: Color(0xff3A557C)),
                                        border: InputBorder.none,
                                        hintText: "Name",
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 2,
                                            color: Color(0xff759AB4))),
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      RegExp regx2 = RegExp(
                                          r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+$");

                                      setState(() {
                                        if (email.text.isEmpty) {
                                          emailcheck = true;
                                          email_error = "Enter the Email";
                                        } else if (!regx2
                                            .hasMatch(email.text)) {
                                          emailcheck = true;
                                          email_error = "Enter the Valid Email";
                                        } else {
                                          emailcheck = false;
                                          email_error = null;
                                        }
                                      });
                                    },
                                    controller: email,
                                    decoration: InputDecoration(
                                        errorText:
                                            emailcheck ? email_error : null,
                                        prefixIconConstraints: BoxConstraints(
                                            maxHeight: 20, minWidth: 30),
                                        prefixIcon: FaIcon(FontAwesomeIcons.box,
                                            size: 15, color: Color(0xff3A557C)),
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 2,
                                            color: Color(0xff759AB4))),
                                  ),
                                  TextField(
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      RegExp regex1 =
                                          RegExp(r'^(\+?91)?[7-9][0-9]{9}$');

                                      setState(() {
                                        if (number.text.isEmpty) {
                                          numbercheck = true;
                                          number_error = "Enter the Number";
                                        } else if (!regex1
                                            .hasMatch(number.text)) {
                                          numbercheck = true;
                                          number_error = "Enter Valid Number";
                                        } else {
                                          numbercheck = false;
                                          number_error = null;
                                        }
                                      });
                                    },
                                    controller: number,
                                    decoration: InputDecoration(
                                        errorText:
                                            numbercheck ? number_error : null,
                                        prefixIconConstraints: BoxConstraints(
                                            maxHeight: 20, minWidth: 30),
                                        prefixIcon: FaIcon(
                                            FontAwesomeIcons.phone,
                                            size: 15,
                                            color: Color(0xff3A557C)),
                                        border: InputBorder.none,
                                        hintText: "Number",
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 2,
                                            color: Color(0xff759AB4))),
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  TextField(
                                    controller: dateController,
                                    decoration: InputDecoration(
                                        errorText:
                                            errorDObcheck ? dob_error : null,
                                        prefixIconConstraints: BoxConstraints(
                                            maxHeight: 20, minWidth: 30),
                                        prefixIcon: FaIcon(
                                            FontAwesomeIcons.birthdayCake,
                                            size: 15,
                                            color: Color(0xff3A557C)),
                                        border: InputBorder.none,
                                        hintText: "Select Your Date of Birth",
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 2,
                                            color: Color(0xff759AB4))),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now());

                                      if (pickedDate != null) {
                                        print(
                                            pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                        formattedDate = DateFormat('dd-MM-yyyy')
                                            .format(
                                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                        print(
                                            formattedDate); //formatted date output using intl package =>  2022-07-04
                                        //You can format date as per your need

                                        setState(() {
                                          dateController.text =
                                              formattedDate; //set formatted date to TextField value.
                                        });
                                        errorDObcheck = false;
                                      } else {
                                        print("Date is not selected");
                                        setState(() {
                                          errorDObcheck = true;
                                          dob_error = "Date is not selected";
                                        });
                                      }
                                    },
                                    readOnly: true,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.trophy,
                                          size: 15, color: Color(0xff3A557C)),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("Qualification",
                                          style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 2,
                                              color: Color(0xff759AB4))),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: twidth * 0.40,
                                        child: DropdownButton(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          elevation: 20,
                                          focusColor: Colors.black,
                                          value: curruntvalue,
                                          items: List.generate(3, (index) {
                                            return DropdownMenuItem(
                                                value: "${items[index]}",
                                                child: Text("${items[index]}"));
                                          }),
                                          onChanged: (value) {
                                            setState(() {
                                              curruntvalue = value!;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    FaIcon(FontAwesomeIcons.mars,
                                        size: 15, color: Color(0xff3A557C)),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("Gender",
                                        style: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 2,
                                            color: Color(0xff759AB4))),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text("Male",
                                        style: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: 2,
                                            color: Colors.black)),
                                    Radio(
                                      fillColor: MaterialStatePropertyAll(
                                          Color(0xff3A557C)),
                                      value: "male",
                                      groupValue: gender,
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          gender = value.toString();
                                        });
                                      },
                                    ),
                                    Text("Female",
                                        style: TextStyle(
                                            fontSize: 13,
                                            letterSpacing: 2,
                                            color: Colors.black)),
                                    Radio(
                                      fillColor: MaterialStatePropertyAll(
                                          Color(0xff3A557C)),
                                      value: "female",
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value.toString();
                                        });
                                      },
                                    )
                                  ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(FontAwesomeIcons.book,
                                          size: 15, color: Color(0xff3A557C)),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("Hobbies   ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 2,
                                              color: Color(0xff759AB4))),
                                      Container(
                                        height: 40,
                                        width: twidth * 0.55,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Text(
                                                "Cricket",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    letterSpacing: 2,
                                                    color: Colors.black),
                                              ),
                                              Checkbox(
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        Color(0xff3A557C)),
                                                value: cricketcheck,
                                                onChanged: (value) {
                                                  print(value);

                                                  setState(() {
                                                    cricketcheck = value!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Reading",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    letterSpacing: 2,
                                                    color: Colors.black),
                                              ),
                                              Checkbox(
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        Color(0xff3A557C)),
                                                value: Readingcheck,
                                                onChanged: (value) {
                                                  setState(() {
                                                    Readingcheck = value!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Travelling",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    letterSpacing: 2,
                                                    color: Colors.black),
                                              ),
                                              Checkbox(
                                                fillColor:
                                                    MaterialStatePropertyAll(
                                                        Color(0xff3A557C)),
                                                value: Travellingcheck,
                                                onChanged: (value) {
                                                  setState(() {
                                                    Travellingcheck = value!;
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      RegExp regx4 = RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                                          multiLine: false,
                                          caseSensitive: false);

                                      setState(() {
                                        if (password.text.isEmpty) {
                                          passcheck = true;
                                          pass_error = "Enter the Password";
                                        } else if (!regx4
                                            .hasMatch(password.text)) {
                                          passcheck = true;
                                          pass_error =
                                              "Enter the Valid Password";
                                        } else {
                                          passcheck = false;
                                          pass_error = null;
                                        }
                                      });
                                    },
                                    controller: password,
                                    obscureText: passwordvisible1,
                                    decoration: InputDecoration(
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
                                        errorText:
                                            passcheck ? pass_error : null,
                                        prefixIconConstraints: BoxConstraints(
                                            maxHeight: 20, minWidth: 30),
                                        prefixIcon: FaIcon(
                                            FontAwesomeIcons.lock,
                                            size: 15,
                                            color: Color(0xff3A557C)),
                                        border: InputBorder.none,
                                        hintText: "Set Password",
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            letterSpacing: 2,
                                            color: Color(0xff759AB4))),
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      EasyLoading.show(status: "Loading...");
                      //
                      // List<int> aa = File(Imagepick).readAsBytesSync();
                      // String imagedata = base64Encode(aa);
                      //
                      // Map userdata = {
                      //   "name": name.text,
                      //   "email": email.text,
                      //   "password": password.text,
                      //   "imagedata": imagedata
                      // };
                      //
                      // var url = Uri.parse(
                      //     'https://vyasenterprize.000webhostapp.com/EcommerceSir/register.php');
                      // var response = await http.post(url, body: userdata);
                      // print('Response status: ${response.statusCode}');
                      // print('Response body: ${response.body}');
                      //
                      // Map<String, dynamic> map = jsonDecode(response.body);

                      List<int> aa = File(Imagepick).readAsBytesSync();

                      String imagedata = base64Encode(aa);

                      Map mydata = {
                        'name': name.text,
                        'email': email.text,
                        'number': number.text,
                        'dob': dateController.text,
                        'qualification': curruntvalue,
                        'gender': gender,
                        // 'hobbies':
                        'password': password.text,
                        'imagedata': imagedata,
                      };

                      var url = Uri.parse(
                          'https://vyasenterprize.000webhostapp.com/MyEcomm/myregister.php');
                      var response = await http.post(url, body: mydata);
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      Map<String, dynamic> mymap = jsonDecode(response.body);

                      RgisterData dd = RgisterData.fromJson(mymap);

                      if (dd.connection == 1) {
                        if (dd.result == 1) {
                          EasyLoading.dismiss();

                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ));
                        } else {
                          EasyLoading.dismiss();

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Already Exist")));
                        }
                      }
                    },
                    child: Container(
                      height: theight * 0.04,
                      width: twidth * 0.9,
                      decoration: BoxDecoration(color: Color(0xff3A557C)),
                      child: Center(
                        child: Text(
                          "Signup".toUpperCase(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Color(0xffEFF2F1)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class RgisterData {
  int? connection;
  int? result;

  RgisterData({this.connection, this.result});

  RgisterData.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    return data;
  }
}
