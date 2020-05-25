import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:http_request_pesponse/user_model.dart';
import 'dart:convert';
import 'HomePage.dart';

void main() {
  runApp(MyApp());
}

var convertedDatatoJsonReg;
var convertedDatatoJsonLog;

bool otpFlag = false;
bool submitFlag = false;
bool firstBtnFlag = true;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future createUser(String phoneNo) async {
  final String apiUrl =
      "http://visitzservice.azurewebsites.net/api/getauthcode-debug";

  var response = await http.post(apiUrl,
      body: phoneNo, headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    print("2. Hi from if Reg");
    convertedDatatoJsonReg = jsonDecode(response.body);

    print(convertedDatatoJsonReg);

    //return userModelFromJson(convertedDatatoJsonReg);
  } else {
    convertedDatatoJsonReg = jsonDecode(response.body);

    print(convertedDatatoJsonReg);
    print("Error !!!");
  }
}

Future loginUser(String phoneNo, String code) async {
  final String apiUrl =
      "http://visitzservice.azurewebsites.net/api/authenticate";

  var response = await http.post(apiUrl + 'authenticate',
      body: json.encode({'PhoneNo': phoneNo, 'Code': code}),
      headers: {'Content-Type': 'application/json'});

  print("from loginUser PhoneNumber : " + phoneNo);
  print("from loginUser OTP : " + code);
  convertedDatatoJsonLog = jsonDecode(response.body);
  //responseString = response.body;
  print(convertedDatatoJsonLog.toString());

  if (response.statusCode == 200) {
    print("Hi from if Log");
    convertedDatatoJsonLog = jsonDecode(response.body);
    //responseString = response.body;
    print(convertedDatatoJsonLog);

    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),) );

    return convertedDatatoJsonLog;
  } else {
    print("Error !!!" + convertedDatatoJsonLog.toString());
    Text(convertedDatatoJsonLog.toString());
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                new TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    prefixIcon: Icon(Icons.perm_identity),
                    hintText: "Enter Phone Number",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                    labelText: "Phone Number",
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                otpFlag == true
                    ? new TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: "One Time Password",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: "OTP"),
                      )
                    : new Text(""),
                SizedBox(
                  height: 32,
                ),
                submitFlag == true
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new RaisedButton(
                          onPressed: () async {
                            final String phNo = phoneController.text;
                            final String otp =
                                convertedDatatoJsonReg.toString();

                            await loginUser(phNo, otp);

                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (Route<dynamic> route) => false);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: Colors.blueAccent,
                          child: Text(
                            "Submit OTP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : new Text(""),
                firstBtnFlag == true
                    ? new RaisedButton(
                        onPressed: () async {
                          final String phNo = phoneController.text;

                          print("1. " + phNo);

                          await createUser(phNo);

                          print("3. hifrom btn " +
                              convertedDatatoJsonReg.toString());

                          setState(() {
                            otpFlag = true;
                          });
                          setState(() {
                            submitFlag = true;
                          });
                          setState(() {
                            firstBtnFlag = false;
                          });
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.blueAccent,
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : new Text(""),
              ],
            ),
          ),
          Container(
            child: Text("OTP : " + convertedDatatoJsonReg.toString()),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
