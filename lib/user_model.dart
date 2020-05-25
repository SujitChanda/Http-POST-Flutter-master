/*import 'dart:convert';

import 'package:http_request_pesponse/main.dart';

//final userModel = userModelFromJson(responseString);

//UserModel userModelFromJson(String str) => userModelFromJson(responseString);

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

//String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String phoneNo;
  String code;

  UserModel({
    this.phoneNo,
    this.code,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        phoneNo: json["PhoneNo"],
        code: json["Code"],
      );

  Map<String, dynamic> toJson() => {
        "PhoneNo": phoneNo,
        "Code": code,
      };
}
*/
