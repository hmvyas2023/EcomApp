import 'dart:convert';
import 'dart:io';

import 'package:ecommapp/SplashScreen.dart';
import 'package:ecommapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomePage extends StatefulWidget {
  Userdata? userdata123;

  HomePage([this.userdata123]);

  static var cnt = "home";

  //cnt  0 = home , 1 = add product , 2 = like page , 3 = cart , 4 = view all product

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  loginclass? lll;

  MyAddProductClass? addproduct;
  MyViewDataClass? myviewproduct;
  AllDataViewClass? viewalldata;
  deleteclass? deleteproduct;
  cartclass? cartproducts;

  TextEditingController searchcontroller = TextEditingController();
  bool isSearch = false;
  bool isCart = true;

  List cartproduct = [];
  List likeProduct = [];

  int total = 0;

  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SplashScreen.myalldata = SplashScreen.prefs!.getString("getdata") ?? "";

    var myalldataMap = jsonDecode(SplashScreen.myalldata);

    lll = loginclass.fromJson(myalldataMap);

    viewproduct();
    viewallproduct();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$PaymentSuccessResponse')));
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$response")));
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$response")));
    // Do something when an external wallet was selected
  }

  String Imagepick = "";

  TextEditingController pname = TextEditingController();
  TextEditingController pprice = TextEditingController();
  TextEditingController pdiscription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double twidth = MediaQuery.of(context).size.width;
    double theight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
              elevation: 20,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Image(
                              image: NetworkImage(
                                  "https://vyasenterprize.000webhostapp.com/MyEcomm/${lll!.userdata!.iMAGEPATH}"),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          "https://vyasenterprize.000webhostapp.com/MyEcomm/${lll!.userdata!.iMAGEPATH}"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${lll!.userdata!.nAME}".toUpperCase(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ExpansionTile(
                    collapsedBackgroundColor: Color(0xffEFF2F1),
                    leading: Icon(CupertinoIcons.profile_circled),
                    iconColor: Color(0xff759AB4),
                    title: Text("Profile",
                        style: TextStyle(fontSize: 15, letterSpacing: 1)),
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text("CONTACT NO:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("${lll!.userdata!.nUMBER}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("DATE OF BIRTH :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("${lll!.userdata!.dOB}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("EMAIL :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(" ${lll!.userdata!.eMAIL}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("GENDER : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("${lll!.userdata!.gENDER}"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("QUALIFICATION :",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(" ${lll!.userdata!.qUALIFICATION}"),
                                  ],
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        setState(() {
                          HomePage.cnt = "addproduct";
                        });
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ));
                    },
                    child: Container(
                      color: Color(0xffEFF2F1),
                      height: 50,
                      child: Row(children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("Add Product",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Color(0xff3A557C))),
                        SizedBox(
                          width: 150,
                        ),
                        Icon(
                          FontAwesomeIcons.add,
                          size: 15,
                          color: Color(0xff3A557C),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        setState(() {
                          HomePage.cnt = "allproduct";
                        });
                      });

                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ));
                    },
                    child: Container(
                      color: Color(0xffEFF2F1),
                      height: 50,
                      child: Row(children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text("View All Product",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Color(0xff3A557C))),
                        SizedBox(
                          width: 115,
                        ),
                        Icon(
                          Icons.view_comfy_rounded,
                          size: 15,
                          color: Color(0xff3A557C),
                        )
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Color(0xff3A557C))),
                      onPressed: () {
                        setState(() {
                          SplashScreen.myScreen = false;

                          HomePage.cnt = "home";

                          SplashScreen.prefs!
                              .setBool("setbool", SplashScreen.myScreen);
                        });

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ));
                      },
                      child: Text("Logout")),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
          appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        HomePage.cnt = "home";

                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                          },
                        ));
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(FontAwesomeIcons.home, size: 20),
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        HomePage.cnt = "like";
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        CupertinoIcons.heart_solid,
                      ),
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        HomePage.cnt = "cart";
                      });
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(FontAwesomeIcons.bagShopping),
                    ))
              ],
              backgroundColor: Color(0xff3A557C),
              title: Row(
                children: [
                  HomePage.cnt == "addproduct"
                      ? Text("Add Product")
                      : HomePage.cnt == "like"
                          ? Text("Liked")
                          : HomePage.cnt == "cart"
                              ? Text("Cart")
                              : HomePage.cnt == "allproduct"
                                  ? Text("All Product")
                                  : Text("MyEcomApp")
                ],
              )),
          body: HomePage.cnt == "addproduct"
              ? Container(
                  height: theight,
                  width: twidth,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 20,
                          child: InkWell(
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
                                                    source: ImageSource.camera);

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
                                                    source:
                                                        ImageSource.gallery);

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
                                ? Container(
                                    height: twidth * 0.6,
                                    width: twidth * 0.6,
                                    color: Color(0xff3A557C),
                                    child: Icon(FontAwesomeIcons.plus,
                                        color: Colors.white),
                                  )
                                : Container(
                                    height: twidth * 0.6,
                                    width: twidth * 0.6,
                                    color: Color(0xff3A557C),
                                    child: Image(
                                        image: FileImage(File(Imagepick)),
                                        fit: BoxFit.cover),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text(
                          "Product Image",
                          style: TextStyle(
                              color: Color(0xff3A557C),
                              fontWeight: FontWeight.bold),
                        )),
                        Container(
                          width: twidth * 0.9,
                          height: theight * 0.35,
                          child: Column(children: [
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: pname,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  prefixIconConstraints: BoxConstraints(
                                      maxHeight: 20, minWidth: 30),
                                  prefixIcon: FaIcon(
                                      FontAwesomeIcons.bagShopping,
                                      size: 20,
                                      color: Color(0xff3A557C)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff3A557C),
                                          style: BorderStyle.solid,
                                          width: 2)),
                                  hintText: "ProductName",
                                  hintStyle: TextStyle(
                                      fontSize: 25,
                                      letterSpacing: 1,
                                      color: Color(0xff759AB4))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: pprice,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  prefixIconConstraints: BoxConstraints(
                                      maxHeight: 20, minWidth: 30),
                                  prefixIcon: FaIcon(
                                      FontAwesomeIcons.indianRupeeSign,
                                      size: 20,
                                      color: Color(0xff3A557C)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff3A557C),
                                          style: BorderStyle.solid,
                                          width: 2)),
                                  hintText: "Price",
                                  hintStyle: TextStyle(
                                      fontSize: 25,
                                      letterSpacing: 1,
                                      color: Color(0xff759AB4))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              textAlignVertical: TextAlignVertical.center,
                              maxLines: 1,
                              controller: pdiscription,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  prefixIconConstraints:
                                      BoxConstraints(minWidth: 30),
                                  prefixIcon: FaIcon(FontAwesomeIcons.fileLines,
                                      size: 20, color: Color(0xff3A557C)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff3A557C),
                                          style: BorderStyle.solid,
                                          width: 2)),
                                  hintText: "Discription",
                                  hintStyle: TextStyle(
                                      fontSize: 25,
                                      letterSpacing: 1,
                                      color: Color(0xff759AB4))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color(0xff3A557C))),
                            onPressed: () async {
                              EasyLoading.show(status: "Adding...");

                              List<int> ll = File(Imagepick).readAsBytesSync();

                              String imagedata = base64Encode(ll);

                              Map myproductdata = {
                                'pname': pname.text,
                                'pprice': pprice.text,
                                'pdiscription': pdiscription.text,
                                'userid': SplashScreen.userid,
                                'productimage': imagedata,
                              };

                              print("============${SplashScreen.userid}"
                                  .runtimeType);

                              var url = Uri.parse(
                                  'https://vyasenterprize.000webhostapp.com/MyEcomm/addproduct.php');
                              var response =
                                  await http.post(url, body: myproductdata);
                              print('Response status: ${response.statusCode}');
                              print('Response body: ${response.body}');

                              Map<String, dynamic> myMap =
                                  jsonDecode(response.body);

                              setState(() {
                                addproduct = MyAddProductClass.fromJson(myMap);
                              });

                              if (addproduct!.connection == 1) {
                                if (addproduct!.result == 1) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Product Added Succesfully")));

                                  EasyLoading.dismiss();

                                  setState(() {
                                    HomePage.cnt = "home";
                                  });

                                  // Navigator.pushReplacement(context,
                                  //     MaterialPageRoute(
                                  //   builder: (context) {
                                  //     return HomePage();
                                  //   },
                                  // ));
                                }
                              }
                            },
                            child: Text("Add Product"))
                      ],
                    ),
                  ))
              : HomePage.cnt == "home"
                  ? Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: 500,
                              // decoration: BoxDecoration(
                              //     color: Color(0xff3A557C).withOpacity(0.95)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Hey, ",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20)),
                                        Text(
                                          "${lll!.userdata!.nAME}"[0]
                                                  .toUpperCase() +
                                              "${lll!.userdata!.nAME}"
                                                  .substring(1)
                                                  .toLowerCase(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.orange),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      " Welcome to our store! We are more than happy to have you on board.",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ),
                            TextField(
                                controller: searchcontroller,
                                onChanged: (value) {
                                  if (searchcontroller.text != "") {
                                    setState(() {
                                      isSearch = true;
                                    });
                                  } else {
                                    setState(() {
                                      isSearch = false;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    fillColor: Color(0xffAEB0B3FF),
                                    hintText: "Search Your Product",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: isSearch
                                        ? Icon(Icons.cancel_outlined,
                                            size: 20, color: Colors.grey)
                                        : Icon(FontAwesomeIcons.search,
                                            size: 18, color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xffAEB0B3FF),
                                            width: 2)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: Color(0xffAEB0B3FF),
                                            width: 2)))),
                            SizedBox(
                              height: 20,
                            ),
                            myviewproduct != null
                                ? Container(
                                    height: theight * 0.7,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          myviewproduct!.productdata!.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 0.5,
                                              crossAxisCount: 2),
                                      itemBuilder: (context, index) {
                                        return Dismissible(
                                          background: Container(
                                            alignment: Alignment.centerLeft,
                                            color: Colors.green,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text('Delete',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white)),
                                                Icon(Icons.delete,
                                                    color: Colors.white),
                                              ],
                                            ),
                                            // color: Colors.green
                                          ),
                                          direction:
                                              DismissDirection.endToStart,
                                          confirmDismiss: (direction) async {
                                            return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("Delete"),
                                                  content: const Text(
                                                      "Are you sure you want to delete this item?"),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                        child:
                                                            const Text("Yes")),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text("No"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          key: ValueKey(myviewproduct!
                                              .productdata![index]),
                                          onDismissed: (direction) async {
                                            EasyLoading.show(
                                                status: "Deleting....");

                                            var mydataaa = {
                                              'pid': myviewproduct!
                                                  .productdata![index].pID
                                            };

                                            var url = Uri.parse(
                                                'https://vyasenterprize.000webhostapp.com/MyEcomm/deleteproduct.php');
                                            var response = await http.post(url,
                                                body: mydataaa);
                                            print(
                                                'Response status: ${response.statusCode}');
                                            print(
                                                ' delete Response body: ${response.body}');

                                            Map<String, dynamic> Mymappp =
                                                jsonDecode(response.body);

                                            deleteproduct =
                                                deleteclass.fromJson(Mymappp);

                                            if (deleteproduct!.result == 1 &&
                                                deleteproduct!.connection ==
                                                    1) {
                                              EasyLoading.dismiss();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text("Deleted")));
                                            } else {
                                              EasyLoading.dismiss();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Something Went Wrong")));
                                            }

                                            setState(() {
                                              myviewproduct!.productdata!
                                                  .removeAt(index);
                                            });
                                          },
                                          child: Card(
                                            elevation: 10,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Column(children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  height: 40,
                                                  width: twidth * 0.8,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          // if (isCart) {
                                                          //   isCart = false;
                                                          // } else {
                                                          //   isCart = true;
                                                          // }
                                                        });

                                                        print(
                                                            "iscart=======$isCart");

                                                        setState(() {
                                                          if (isCart) {
                                                            likeProduct.add(
                                                                myviewproduct!
                                                                    .productdata![
                                                                        index]
                                                                    .toJson());
                                                          }
                                                        });

                                                        print(likeProduct);
                                                      },
                                                      icon: isCart
                                                          ? Icon(
                                                              size: 30,
                                                              CupertinoIcons
                                                                  .heart_fill,
                                                              color:
                                                                  Colors.grey,
                                                            )
                                                          : Icon(
                                                              size: 30,
                                                              CupertinoIcons
                                                                  .heart_fill,
                                                              color: Colors.red,
                                                            )),
                                                ),
                                                Image(
                                                    width: twidth * 0.45,
                                                    height: 150,
                                                    image: NetworkImage(
                                                        "https://vyasenterprize.000webhostapp.com/MyEcomm/${myviewproduct!.productdata![index].pIMAGE}"),
                                                    fit: BoxFit.cover),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "${myviewproduct!.productdata![index].pNAME}"
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.orangeAccent,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text("PRICE:",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                        "${myviewproduct!.productdata![index].pPRICE}/-",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff3A557C))),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "(25% Off)",
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topStart,
                                                  child: Text("DISCRIPTION:",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: 65,
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                        "${myviewproduct!.productdata![index].pDISCRIPTION}",
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 25,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStatePropertyAll(
                                                            BeveledRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8))),
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Color(
                                                                    0xff3A557C)),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          cartproduct.add(
                                                              myviewproduct!
                                                                  .productdata![
                                                                      index]
                                                                  .toJson());
                                                        });
                                                        print(cartproduct);

                                                        int cnt = int.parse(
                                                            "${cartproduct[index]['PPRICE']}");

                                                        print(cnt);

                                                        setState(() {
                                                          total = total + cnt;
                                                        });

                                                        print(
                                                            "total=========$total");

                                                        // for (int i = 0; i < cartproduct.length; i++) {
                                                        //
                                                        //   int cnt = int.parse("${cartproduct[i]['PPRICE']}");
                                                        //
                                                        //   print(cnt);
                                                        //
                                                        //   total = total + cnt;
                                                        //
                                                        //   print(total);
                                                        // }
                                                      },
                                                      child: Text(
                                                        "Add to cart",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      )),
                                                )
                                              ]),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 180,
                                      ),
                                      Center(
                                          child: Container(
                                        child: Lottie.asset(
                                            height: 150,
                                            width: 150,
                                            "lottie/bluedotloading.json",
                                            fit: BoxFit.fill),
                                      )),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    )
                  : HomePage.cnt == "cart"
                      ? cartproduct.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Lottie.asset(
                                      "lottie/emptycart123.json",
                                    ),
                                  ],
                                ),
                                Text("Cart is Empty",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff3A557C),
                                        fontSize: 25)),
                              ],
                            )
                          : Container(
                              height: theight,
                              width: twidth,
                              child: Column(
                                children: [
                                  Container(
                                    height: theight * 0.6,
                                    width: twidth * 0.98,
                                    child: ListView.builder(
                                      itemCount: cartproduct.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: SizedBox(
                                            width: 70,
                                            height: 120,
                                            child: Image(
                                                image: NetworkImage(
                                                    "https://vyasenterprize.000webhostapp.com/MyEcomm/${cartproduct[index]['PIMAGE']}"),
                                                fit: BoxFit.cover),
                                          ),
                                          title: Card(
                                              child: Container(
                                            width: twidth,
                                            height: 80,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${cartproduct[index]['PNAME']}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "${cartproduct[index]['PDISCRIPTION']}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 7),
                                                    )
                                                  ]),
                                            ),
                                          )),
                                          subtitle: Card(
                                              child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  color: Color(0xff3A557C),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "PRICE",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            letterSpacing: 2),
                                                      ),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Text(
                                                          "${cartproduct[index]['PPRICE']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ))),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: Color(0xff3A557C),
                                    height: 20,
                                    width: twidth,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 2),
                                      child: Row(
                                        children: [
                                          Text("TOTAL",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  letterSpacing: 3)),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text("$total",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    letterSpacing: 3)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  ElevatedButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Color(0xff3A557C))),
                                      onPressed: () {
                                        var options = {
                                          'key': 'rzp_test_GqqrrXfVALEpbL',
                                          'amount': total * 100,
                                          'name': '${lll!.userdata!.nAME}',
                                          'description': 'All Items',
                                          'prefill': {
                                            'contact':
                                                '${lll!.userdata!.nUMBER}',
                                            'email': '${lll!.userdata!.eMAIL}'
                                          }
                                        };

                                        razorpay.open(options);
                                      },
                                      icon: Icon(Icons.payment),
                                      label: Text("Click to Pay"))
                                ],
                              ),
                            )
                      : HomePage.cnt == "allproduct"
                          ? viewalldata != null
                              ? Container(
                                  height: theight * 0.9,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: viewalldata!.productdata!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.5,
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      return Dismissible(
                                        background: Container(
                                          alignment: Alignment.centerLeft,
                                          color: Colors.green,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: const [
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                              Icon(Icons.delete,
                                                  color: Colors.white),
                                            ],
                                          ),
                                          // color: Colors.green
                                        ),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) async {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text("Delete"),
                                                content: const Text(
                                                    "Are you sure you want to delete this item?"),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: const Text("Yes")),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: const Text("No"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        key: ValueKey(
                                            viewalldata!.productdata![index]),
                                        onDismissed: (direction) async {
                                          EasyLoading.show(
                                              status: "Deleting....");

                                          var mydataaa = {
                                            'pid': viewalldata!
                                                .productdata![index].pID
                                          };

                                          var url = Uri.parse(
                                              'https://vyasenterprize.000webhostapp.com/MyEcomm/deleteproduct.php');
                                          var response = await http.post(url,
                                              body: mydataaa);
                                          print(
                                              'Response status: ${response.statusCode}');
                                          print(
                                              ' delete Response body: ${response.body}');

                                          Map<String, dynamic> Mymappp =
                                              jsonDecode(response.body);

                                          deleteproduct =
                                              deleteclass.fromJson(Mymappp);

                                          if (deleteproduct!.result == 1 &&
                                              deleteproduct!.connection == 1) {
                                            EasyLoading.dismiss();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text("Deleted")));
                                          } else {
                                            EasyLoading.dismiss();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Something Went Wrong")));
                                          }

                                          setState(() {
                                            viewalldata!.productdata!
                                                .removeAt(index);
                                          });
                                        },
                                        child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(children: [
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                height: 40,
                                                width: twidth * 0.8,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        // if (isCart) {
                                                        //   isCart = false;
                                                        // } else {
                                                        //   isCart = true;
                                                        // }
                                                      });

                                                      print(
                                                          "iscart=======$isCart");

                                                      setState(() {
                                                        if (isCart) {
                                                          likeProduct.add(
                                                              myviewproduct!
                                                                  .productdata![
                                                                      index]
                                                                  .toJson());
                                                        }
                                                      });

                                                      print(likeProduct);
                                                    },
                                                    icon: isCart
                                                        ? Icon(
                                                            size: 30,
                                                            CupertinoIcons
                                                                .heart_fill,
                                                            color: Colors.grey,
                                                          )
                                                        : Icon(
                                                            size: 30,
                                                            CupertinoIcons
                                                                .heart_fill,
                                                            color: Colors.red,
                                                          )),
                                              ),
                                              Image(
                                                  width: twidth * 0.45,
                                                  height: 150,
                                                  image: NetworkImage(
                                                      "https://vyasenterprize.000webhostapp.com/MyEcomm/${viewalldata!.productdata![index].pIMAGE}"),
                                                  fit: BoxFit.cover),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "${viewalldata!.productdata![index].pNAME}"
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    color: Colors.orangeAccent,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Text("PRICE:",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      "${viewalldata!.productdata![index].pPRICE}/-",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color(
                                                              0xff3A557C))),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "(25% Off)",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                alignment: AlignmentDirectional
                                                    .topStart,
                                                child: Text("DISCRIPTION:",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 65,
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                      "${viewalldata!.productdata![index].pDISCRIPTION}",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                height: 25,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStatePropertyAll(
                                                          BeveledRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8))),
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Color(
                                                                  0xff3A557C)),
                                                    ),
                                                    onPressed: () async {
                                                      var mydataaa = {
                                                        'pid': viewalldata!
                                                            .productdata![index]
                                                            .pID
                                                      };

                                                      var url = Uri.parse(
                                                          'https://vyasenterprize.000webhostapp.com/MyEcomm/cartproduct.php');
                                                      var response =
                                                          await http.post(url,
                                                              body: mydataaa);
                                                      print(
                                                          'Response status: ${response.statusCode}');
                                                      print(
                                                          ' cart Response body: ${response.body}');

                                                      Map<String, dynamic>
                                                          Mymappp = jsonDecode(
                                                              response.body);

                                                      var Mymaaaaap =
                                                          jsonDecode(
                                                              response.body);

                                                      cartproducts = cartclass
                                                          .fromJson(Mymappp);

                                                      print(
                                                          "${cartproducts!.productdata!.length}");

                                                      setState(() {
                                                        cartproduct.add(
                                                            viewalldata!
                                                                .productdata![
                                                                    index]
                                                                .toJson());
                                                      });
                                                      print(cartproduct);
                                                    },
                                                    child: Text(
                                                      "Add to cart",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                              )
                                            ]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  child: Center(
                                    child: Lottie.asset(
                                      width: 100,
                                      height: 100,
                                      "lottie/bluedotloading.json",
                                    ),
                                  ),
                                )
                          : Container(
                              child: Center(child: Text("liked page")),
                            )), //likepage
    );
  }

  Future<void> viewproduct() async {
    var mydata123 = {'uerid': SplashScreen.userid};

    var url = Uri.parse(
        'https://vyasenterprize.000webhostapp.com/MyEcomm/viewdata.php');
    var response = await http.post(url, body: mydata123);
    print('Response status: ${response.statusCode}');
    print('view product Response body: ${response.body}');

    var myMapp = jsonDecode(response.body);

    if (this.mounted) {
      setState(() {
        myviewproduct = MyViewDataClass.fromJson(myMapp);
      });
    }
  }

  Future<void> viewallproduct() async {
    var url = Uri.parse(
        'https://vyasenterprize.000webhostapp.com/MyEcomm/viewalldata.php');
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Map<String, dynamic> myMaaap = jsonDecode(response.body.toString());

    if (this.mounted) {
      setState(() {
        viewalldata = AllDataViewClass.fromJson(myMaaap);
      });
    }
  }
}

class MyAddProductClass {
  int? connection;
  int? result;

  MyAddProductClass({this.connection, this.result});

  MyAddProductClass.fromJson(Map<String, dynamic> json) {
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

class AllDataViewClass {
  int? connection;
  int? result;
  List<Productdata>? productdata;

  AllDataViewClass({this.connection, this.result, this.productdata});

  AllDataViewClass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    if (json['productdata'] != null) {
      productdata = <Productdata>[];
      json['productdata'].forEach((v) {
        productdata!.add(new Productdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.productdata != null) {
      data['productdata'] = this.productdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productdata {
  String? pID;
  String? pNAME;
  String? pPRICE;
  String? pDISCRIPTION;
  String? pIMAGE;
  String? uSERID;

  Productdata(
      {this.pID,
      this.pNAME,
      this.pPRICE,
      this.pDISCRIPTION,
      this.pIMAGE,
      this.uSERID});

  Productdata.fromJson(Map<String, dynamic> json) {
    pID = json['PID'];
    pNAME = json['PNAME'];
    pPRICE = json['PPRICE'];
    pDISCRIPTION = json['PDISCRIPTION'];
    pIMAGE = json['PIMAGE'];
    uSERID = json['USERID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PID'] = this.pID;
    data['PNAME'] = this.pNAME;
    data['PPRICE'] = this.pPRICE;
    data['PDISCRIPTION'] = this.pDISCRIPTION;
    data['PIMAGE'] = this.pIMAGE;
    data['USERID'] = this.uSERID;
    return data;
  }
}

class MyViewDataClass {
  int? connection;
  int? result;
  List<Productdata>? productdata;

  MyViewDataClass({this.connection, this.result, this.productdata});

  MyViewDataClass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    if (json['productdata'] != null) {
      productdata = <Productdata>[];
      json['productdata'].forEach((v) {
        productdata!.add(new Productdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.productdata != null) {
      data['productdata'] = this.productdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class deleteclass {
  int? connection;
  int? result;

  deleteclass({this.connection, this.result});

  deleteclass.fromJson(Map<String, dynamic> json) {
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

class cartclass {
  int? connection;
  int? result;
  List<Productdata>? productdata;

  cartclass({this.connection, this.result, this.productdata});

  cartclass.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    if (json['productdata'] != null) {
      productdata = <Productdata>[];
      json['productdata'].forEach((v) {
        productdata!.add(new Productdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.productdata != null) {
      data['productdata'] = this.productdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
